require 'rails_helper'

RSpec.describe "snapshots/index", type: :view do
  before(:each) do
    assign(:snapshots, [
      Snapshot.create!(
        :origin => "Origin",
        :data_name => "Data Name",
        :query => "Query",
        :content => "MyText",
        :headers => "MyText"
      ),
      Snapshot.create!(
        :origin => "Origin",
        :data_name => "Data Name",
        :query => "Query",
        :content => "MyText",
        :headers => "MyText"
      )
    ])
  end

  it "renders a list of snapshots" do
    render
    assert_select "tr>td", :text => "Origin".to_s, :count => 2
    assert_select "tr>td", :text => "Data Name".to_s, :count => 2
    assert_select "tr>td", :text => "Query".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
