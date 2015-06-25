require 'rails_helper'

RSpec.describe "reports/new", :type => :view do
  before(:each) do
    assign(:report, Report.new(
      :email => "real@email.com",
      :description => "MyText",
      :cause => "MyString"
    ))
  end

  it "renders new report form" do
    render

    assert_select "form[action=?][method=?]", reports_path, "post" do

      assert_select "input#report_email[name=?]", "report[email]"

      assert_select "textarea#report_description[name=?]", "report[description]"

      assert_select "input#report_cause[name=?]", "report[cause]"
    end
  end
end
