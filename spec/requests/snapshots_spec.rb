require 'rails_helper'

RSpec.describe "Snapshots", type: :request do
  describe "GET /snapshots" do
    it "works! (now write some real specs)" do
      get snapshots_path
      expect(response).to have_http_status(200)
    end
  end
end
