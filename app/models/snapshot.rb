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
      tracker_stories_reverse stories, activities, params[:tracker_project]
    end

    # collect stories
    def tracker_stories(project)
      snapshot = Snapshot.where(query: "projects/#{project}/stories")
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
      snapshot = Snapshot.where(query: "projects/#{project}/activity")
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

    # reverse stories
    def tracker_stories_reverse(stories, activities, project)
      activities.each do |activity|
        if activity[:kind].eql? 'story_update_activity'
          stories = reverse_story_update(stories, activity, project)
        elsif activity[:kind].eql? 'story_move_activity'
          stories = reverse_story_move(stories, activity, project)
        end
      end
    end

    # reverse story_update_activity
    def reverse_story_update(stories, action, project)
      action[:changes].each do |change|
        story = stories.find { |s| s[:id].eql? change[:id] }
        story.update change[:original_values]
      end
      create(origin: 'pivotal_tracker',
             data_name: 'stories',
             project_id: project,
             content: stories.to_json,
             taken_at: action[:occurred_at])
      stories
    end

    # reverse story_move_activity
    def reverse_story_move(stories, action, project)
      stories
    end

  end
end
