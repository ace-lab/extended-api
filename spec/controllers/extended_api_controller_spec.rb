require 'rails_helper'

RSpec.describe ExtendedApiController, type: :controller do
  describe 'GET stories' do
    it 'should call Snapshot.tracker_stories_at with the right parameters' do
      expect(Snapshot).to receive(:tracker_stories_at).with('1', Time.at(100))
      get 'stories', params: { pid: 1, at_time: 100 }
    end
  end

end
