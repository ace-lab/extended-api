class Snapshot < ApplicationRecord

  # class methods
  class << self
    # create snapshots for pivotal tracker data
    def create_tracker(params)
      @conn = Faraday.new(url: 'https://www.pivotaltracker.com/services/v5')
      @conn.headers['Content-Type'] = 'application/json'
      @conn.headers['X-TrackerToken'] = params[:tracker_token]

      activities = tracker_activities params[:tracker_project]

      stories = tracker_stories params[:tracker_project]
      tracker_stories_reverse stories, activities
    end

    # collect stories
    def tracker_stories(project)
      snapshot = where(query: "projects/#{project}/stories")
      return JSON.parse(snapshot.last.content, symbolize_names: true) unless snapshot.empty?

      resp = @conn.get("projects/#{project}/stories")
      create(origin: 'pivotal_tracker',
             data_name: 'stories',
             project_id: project,
             query: "projects/#{project}/stories",
             content: resp.body,
             headers: resp.headers.to_json,
             taken_at: Time.now)
      JSON.parse(resp.body, symbolize_names: true)
    end

    # collect activities
    def tracker_activities(project)
      snapshot = where(query: "projects/#{project}/activity")
      return JSON.parse(snapshot.last.content, symbolize_names: true) unless snapshot.empty?

      resp = @conn.get("projects/#{project}/activity")
      create(origin: 'pivotal_tracker',
             data_name: 'activities',
             project_id: project,
             query: "projects/#{project}/activity",
             content: resp.body,
             headers: resp.headers.to_json,
             taken_at: Time.now)
      JSON.parse(resp.body, symbolize_names: true)
    end

    # get tracker stories at a given time
    def tracker_stories_at(project, time_at)
      stories = tracker_stories project
      activities = tracker_activities(project).select { |el| Time.iso8601(el[:occurred_at]) > time_at }
      snapshot = reuse_snapshot(activities.last, project)
      return JSON.parse(snapshot.content, symbolize_names: true) unless snapshot.nil?

      reversed_stories = tracker_stories_reverse(stories, activities)
      create(origin: 'pivotal_tracker',
             data_name: 'activities',
             project_id: project,
             query: create_query_str(activities.last, project),
             content: reversed_stories.to_json,
             taken_at: time_at)
      reversed_stories
    end

    def reuse_snapshot(last_activity, project)
      query_str = create_query_str(last_activity, project)
      Snapshot.where(query: query_str).last
    end

    # Look for previous saved snapshots
    def create_query_str(last_activity, project)
      if last_activity.nil?
        "projects/#{project}/stories"
      else
        "extended_api/projects/#{project}/stories?before_id=#{last_activity[:guid]}"
      end
    end

    # reverse stories
    def tracker_stories_reverse(stories, activities)
      activities.each do |activity|
        if activity[:kind].eql? 'story_update_activity'
          stories = reverse_story_update(stories, activity)
        elsif activity[:kind].eql? 'story_move_activity'
          stories = reverse_story_move(stories, activity)
        elsif activity[:kind].eql? 'story_create_activity'
          stories = reverse_story_create(stories, activity)
        elsif activity[:kind].eql? 'story_delete_activity'
          stories = reverse_story_delete(stories, activity)
        end
      end
      stories
    end

    # reverse story_update_activity
    def reverse_story_update(stories, action)
      action[:changes].each do |change|
        story_ind = stories.find_index { |s| s[:id].eql? change[:id] }
        stories[story_ind].update change[:original_values]
      end
      stories
    end

    # reverse story_move_activity
    def reverse_story_move(stories, action)
      action[:changes].each do |change|
        story = stories.delete_at(stories.find_index { |el| el[:id].eql? change[:id] })
        next_index = stories.find_index { |el| el[:id].eql? change[:original_values][:before_id] }
        if next_index.nil?
          prev_index = stories.find_index { |el| el[:id].eql? change[:original_values][:after_id] }
          if prev_index.nil?
            story = story.update change[:original_values]
            next_index = stories.find_index { |el| el[:state].eql? 'unscheduled' }
            next_index = stories.length if next_index.nil?
          else
            next_index = prev_index + 1
          end
        end
        stories.insert(next_index, story)
      end
      stories
    end

    # reverse story_create_activity
    def reverse_story_create(stories, action)
      action[:changes].each do |change|
        stories = stories.delete_if { |el| el[:id].eql? change[:id] }
      end
      stories
    end

    # reverse story_delete_activity
    def reverse_story_delete(stories, action)
      # It loses information!
      action[:primary_resources].each do |story|
        stories.push story
      end
      stories
    end

  end
end
