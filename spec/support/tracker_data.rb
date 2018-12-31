module TrackerData
  def stories
    JSON.parse(file_fixture('tracker_stories.json').read, symbolize_names: true)
  end

  def update_activity
    JSON.parse(file_fixture('tracker_story_update_activity.json').read, symbolize_names: true)
  end

  def move_activity
    JSON.parse(file_fixture('tracker_story_move_activity.json').read, symbolize_names: true)
  end
end