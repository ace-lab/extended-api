require 'rails_helper'
require 'support/features/service_config'

RSpec.configure do |c|
  c.include ServiceConfig
end

RSpec.feature 'Collect data from remote', type: :feature do
  scenario 'collect pivotal tracker data' do
    visit new_snapshot_path
    fill_in 'tracker_project', with: tracker_config[:tracker_project]
    fill_in 'tracker_token', with: tracker_config[:tracker_token]
    click_button 'Submit'
    expect(page).to have_text('Snapshot was successfully created')
  end
end
