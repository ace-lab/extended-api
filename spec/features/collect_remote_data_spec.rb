require 'rails_helper'
require 'support/tracker_api'

RSpec.configure do |config|
  config.include TrackerApi
end

RSpec.feature 'Collect data from remote', type: :feature do
  before :each do
    stub_tracker
    Snapshot.tracker_stories(1)
    Snapshot.tracker_activities(1)
  end

  scenario 'collect pivotal tracker data' do
    visit new_snapshot_path
    fill_in 'tracker_project', with: 1
    fill_in 'tracker_token', with: 'token'
    click_button 'Submit'
    expect(page).to have_text('Snapshot was successfully created')
  end

  scenario 'query the very beginning of the project' do
    visit stories_extended_api_path(pid: 1, at_time: 0)
    expect(page).to have_text('[]')
  end

  scenario 'query the latest view' do
    visit stories_extended_api_path(pid: 1)
    expect(page).to have_text('2018-12-17T19:03:19Z')
  end

  scenario 'query a view in the middle' do
    # It reverses the last two activities
    visit stories_extended_api_path(pid: 1, at_time: t_before_second_activity)
    expect(page).to have_text('2018-12-17T18:59:32Z')
  end

  scenario 'query story transitions' do
    visit transitions_extended_api_path(pid: 1, sid: 160837077)
    expect(page).to have_text('2018-12-17T18:59:56Z')
  end
end
