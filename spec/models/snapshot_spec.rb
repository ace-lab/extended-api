require 'rails_helper'
require 'support/tracker_data'
require 'support/tracker_api'

RSpec.configure do |config|
  config.include TrackerData
  config.include TrackerApi
end

RSpec.describe Snapshot, type: :model do

  context 'tracker_stories_at' do
    before :each do
      stub_tracker
      described_class.create_tracker(tracker_token: 'test', tracker_project: 1)
    end

    it 'gives the right result' do
      reversed_stories = described_class.tracker_stories_at(1, Time.at(t_before_first_activity))
      updated_story = reversed_stories.find { |el| el[:id].eql? 160837072 }
      expect(updated_story[:owner_ids].length).to eq(1)
      expect(updated_story[:updated_at]).to eq('2018-12-17T19:03:09Z')
    end

    it 'returns the right result when no history' do
      expect(described_class).to receive(:reuse_snapshot).and_return(nil)
      reversed_stories = described_class.tracker_stories_at(1, Time.at(t_before_first_activity))
      updated_story = reversed_stories.find { |el| el[:id].eql? 160837072 }
      expect(updated_story[:owner_ids].length).to eq(1)
      expect(updated_story[:updated_at]).to eq('2018-12-17T19:03:09Z')
    end
  end

  context 'reverse a story update activity' do
    it 'reverses story update activity' do
      reversed_stories = described_class.reverse_story_update(stories, update_activity)
      updated_story = reversed_stories.find { |el| el[:id].eql? 160837072 }
      expect(updated_story[:owner_ids].length).to eq(1)
      expect(updated_story[:updated_at]).to eq('2018-12-17T19:03:09Z')
    end

    it 'tries to update the story' do
      @s1 = double('Story 1')
      allow(@s1).to receive(:[]).with(:id).and_return(1)
      @s2 = double('Story 2')
      allow(@s2).to receive(:[]).with(:id).and_return(2)
      @stub_stories = [@s1, @s2]

      @activity = double('Update activity')
      allow(@activity).to receive(:[]).and_return([{ id: 1, original_values: 'test' }])

      expect(@s1).to receive(:update).with('test')
      described_class.reverse_story_update(@stub_stories, @activity)
    end
  end
end

