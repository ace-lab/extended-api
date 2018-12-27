require 'rails_helper'

RSpec.describe "snapshots/show", type: :view do
  before(:each) do
    @snapshot = assign(:snapshot, Snapshot.create!(
      :origin => "Origin",
      :data_name => "Data Name",
      :query => "Query",
      :content => "MyText",
      :headers => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Origin/)
    expect(rendered).to match(/Data Name/)
    expect(rendered).to match(/Query/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
