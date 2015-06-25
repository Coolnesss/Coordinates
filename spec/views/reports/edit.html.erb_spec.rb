require 'rails_helper'

RSpec.describe "reports/edit", :type => :view do
  before(:each) do
    @report = assign(:report, Report.create!(
      :email => "real@email.com",
      :description => "MyText",
      :cause => "MyString"
    ))
  end

  it "renders the edit report form" do
    render

    assert_select "form[action=?][method=?]", report_path(@report), "post" do

      assert_select "input#report_email[name=?]", "report[email]"

      assert_select "textarea#report_description[name=?]", "report[description]"

      assert_select "input#report_cause[name=?]", "report[cause]"
    end
  end
end
