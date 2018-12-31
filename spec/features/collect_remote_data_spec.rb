require 'rails_helper'

RSpec.feature 'Collect data from remote', type: :feature do
  before :all do
    stub_request(:get, 'https://www.pivotaltracker.com/services/v5/projects/1/stories')
        .to_return(body: file_fixture('tracker_stories.json').read)
    stub_request(:get, 'https://www.pivotaltracker.com/services/v5/projects/1/activity')
        .to_return(body: file_fixture('tracker_activities.json').read)
  end

  scenario 'collect pivotal tracker data' do
    visit new_snapshot_path
    fill_in 'tracker_project', with: 1
    fill_in 'tracker_token', with: 'token'
    click_button 'Submit'
    expect(page).to have_text('Snapshot was successfully created')
  end
end
