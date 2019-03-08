require 'rails_helper'

RSpec.describe ExtendedApiController, type: :controller do
  describe 'GET stories' do
    it 'should call Snapshot.tracker_stories_at with the right parameters' do
      expect(Snapshot).to receive(:replay_stories_at).with('1', Time.at(100))
      get 'stories', params: { pid: 1, at_time: 100 }
    end
  end

  describe 'GET /extended_api/projects/1/stories/1/transitions' do
    before :each do
      stub_tracker(1)
      Snapshot.create_tracker(tracker_project: 1, tracker_token: 'test')
    end

    it 'calls the right model method' do
      snapshot = double('snapshot')
      expect(Snapshot).to receive(:find_by).with(query: 'projects/1/activity').and_return(snapshot)
      expect(snapshot).to receive(:story_transitions).with(2).and_return([])
      get 'story_transitions', params: { pid: 1, sid: 2 }
    end
  end

end
