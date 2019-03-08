module TrackerData
  def stories
    @tracker_stories ||= JSON.parse(file_fixture('tracker_stories.json').read, symbolize_names: true)
  end

  def activities
    @tracker_activities ||= JSON.parse(file_fixture('tracker_activities.json').read, symbolize_names: true)
  end

  def update_activity
    @tracker_update_activity ||= JSON.parse(file_fixture('tracker_story_update_activity.json').read, symbolize_names: true)
  end

  def move_activity
    @tracker_move_activity ||= JSON.parse(file_fixture('tracker_story_move_activity.json').read, symbolize_names: true)
  end

  def create_activity
    @tracker_create_activity ||= JSON.parse(file_fixture('tracker_story_create_activity.json').read, symbolize_names: true)
  end

  def delete_activity
    @tracker_delete_activity ||= JSON.parse(file_fixture('tracker_story_delete_activity.json').read, symbolize_names: true)
  end
end