require 'rails_helper'

RSpec.describe "snapshots/new", type: :view do
  before(:each) do
    assign(:snapshot, Snapshot.new(
      :origin => "MyString",
      :data_name => "MyString",
      :query => "MyString",
      :content => "MyText",
      :headers => "MyText"
    ))
  end

  it "renders new snapshot form" do
    render

    assert_select "form[action=?][method=?]", snapshots_path, "post" do

      assert_select "input[name=?]", "snapshot[origin]"

      assert_select "input[name=?]", "snapshot[data_name]"

      assert_select "input[name=?]", "snapshot[query]"

      assert_select "textarea[name=?]", "snapshot[content]"

      assert_select "textarea[name=?]", "snapshot[headers]"
    end
  end
end
