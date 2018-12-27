require 'rails_helper'

RSpec.describe "snapshots/edit", type: :view do
  before(:each) do
    @snapshot = assign(:snapshot, Snapshot.create!(
      :origin => "MyString",
      :data_name => "MyString",
      :query => "MyString",
      :content => "MyText",
      :headers => "MyText"
    ))
  end

  it "renders the edit snapshot form" do
    render

    assert_select "form[action=?][method=?]", snapshot_path(@snapshot), "post" do

      assert_select "input[name=?]", "snapshot[origin]"

      assert_select "input[name=?]", "snapshot[data_name]"

      assert_select "input[name=?]", "snapshot[query]"

      assert_select "textarea[name=?]", "snapshot[content]"

      assert_select "textarea[name=?]", "snapshot[headers]"
    end
  end
end
