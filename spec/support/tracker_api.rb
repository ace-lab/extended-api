module TrackerApi
  def stub_tracker
    stub_stories
    stub_activities
  end

  def stub_stories
    stub_request(:get, 'https://www.pivotaltracker.com/services/v5/projects/1/stories')
        .to_return(body: file_fixture('tracker_stories.json').read)
  end

  def stub_activities
    stub_request(:get, 'https://www.pivotaltracker.com/services/v5/projects/1/activity')
        .to_return(body: file_fixture('tracker_activities.json').read)
  end

  def t_before_second_activity
    activities = JSON.parse(file_fixture('tracker_activities.json').read)
    Time.iso8601(activities.second['occurred_at']).to_i - 1
  end

  def t_before_first_activity
    activities = JSON.parse(file_fixture('tracker_activities.json').read)
    Time.iso8601(activities.first['occurred_at']).to_i - 1
  end

end