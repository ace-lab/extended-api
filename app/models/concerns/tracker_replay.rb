module TrackerReplay

  # It replays activities.
  class Replay
    attr_reader :stories

    def initialize(activities)
      @activities = activities.reverse
      @stories = []
    end

    def replay
      @activities.each do |activity|
        act_kind = activity[:kind]
        if Replay.method_defined? act_kind
          send(act_kind, activity)
        end
      end
    end

    def story_update_activity(act)
      sid = act[:primary_resources].first[:id]
      act[:changes].each do |change|
        next unless change[:id].eql? sid

        story_ind = @stories.find_index { |s| s[:id].eql? sid }
        if story_ind.nil?
          @stories.push(act[:primary_resources].first)
          story_ind = @stories.length - 1
        end
        @stories[story_ind].update change[:new_values]
        reorder_story(story_ind)
      end
    end

    def story_move_activity(act)
      sid = act[:primary_resources].first[:id]
      act[:changes].each do |change|
        next unless change[:id].eql? sid

        story_ind = @stories.find_index { |s| s[:id].eql? sid }
        if story_ind.nil?
          @stories.push(act[:primary_resources].first)
          story_ind = @stories.length - 1
        end
        @stories[story_ind].update change[:new_values]
        reorder_story(story_ind)
      end
    end

    def story_create_activity(act)
      act[:changes].each do |change|
        next unless change[:kind].eql? 'story'

        @stories.push(change[:new_values])
        reorder_story(@stories.length - 1)
      end
    end

    def story_delete_activity(act)
      act[:changes].each do |change|
        @stories.delete_if { |el| el[:id].eql? change[:id] }
      end
    end

    def reorder_story(story_ind)
      story = @stories.delete_at(story_ind)
      before_id = story.delete(:before_id)
      after_id = story.delete(:after_id)
      next_ind = @stories.find_index { |el| el[:id].eql? before_id }
      if next_ind.nil?
        prev_ind = @stories.find_index { |el| el[:id].eql? after_id }
        next_ind = prev_ind.nil? ? story_ind : prev_ind + 1
      end
      @stories.insert(next_ind, story)
    end
  end
end