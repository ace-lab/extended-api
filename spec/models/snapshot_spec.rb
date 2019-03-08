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

  context 'replay_stories_at' do
    before :each do
      stub_tracker
      described_class.create_tracker(tracker_token: 'test', tracker_project: 1)
    end

    it 'gives the right results' do
      curr_stories = described_class.replay_stories_at(1, Time.now.to_i)
      expected_stories = JSON.parse(file_fixture('tracker_stories.json').read)
      expected_order = expected_stories.map { |el| el['id'] }
      expected_owners = expected_stories.map { |el| el['owner_ids']}

      expect(curr_stories.map { |el| el[:id] }).to eq(expected_order)
      expect(curr_stories.map { |el| el[:owner_ids] }).to eq(expected_owners)
    end
  end

  context 'reverse_story_update' do
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

  context 'reverse_story_move' do
    it 'reverses story move activity' do
      moved_story_id = move_activity[:primary_resources].first[:id]
      expect { described_class.reverse_story_move(stories, move_activity) }
          .to change { stories.find_index { |el| el[:id].eql? moved_story_id }}.by(-1)
    end
  end

  context 'reverse_story_create' do
    it 'reverses story create activity' do
      expect { described_class.reverse_story_create(stories, create_activity)}
        .to change { stories.length }.by(-1)
    end
  end

  context 'reverse_story_delete' do
    it 'reverses the story delete activity' do
      expect { described_class.reverse_story_delete(stories, delete_activity)}
        .to change { stories.length }.by(1)
    end
  end

  context 'story_transitions' do
    it 'collects transitions of a story' do
      s = Snapshot.new(content: activities.to_json)
      expect(s.story_transitions(160837077).length).to eql(2)
    end

    it 'has the value correctly' do
      transitions = Snapshot.new(content: activities.to_json).story_transitions(160837077)
      expect(transitions.first).to include(:kind, :state, :story_id, :project_id, :project_version, :occurred_at, :performed_by_id)
    end
  end
end

