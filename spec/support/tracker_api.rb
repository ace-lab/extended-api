module TrackerApi
  def stub_tracker(pid = 1)
    stub_stories pid
    stub_activities pid
  end

  def stub_stories(pid)
    stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/#{pid}/stories")
        .to_return(body: file_fixture('tracker_stories.json').read)
  end

  def stub_activities(pid)
    stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/#{pid}/activity?limit=1000")
        .to_return(body: file_fixture('tracker_activities.json').read,
                   headers: { 'X-Tracker-Pagination-Offset' => 0,
                              'X-Tracker-Pagination-Returned' => 20,
                              'X-Tracker-Pagination-Total' => 20 })
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