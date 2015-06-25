require 'rails_helper'

RSpec.describe "reports/index", :type => :view do
  before(:each) do
    assign(:reports, [
      Report.create!(
        :email => "real@email.com",
        :description => "MyText",
        :cause => "Cause"
      ),
      Report.create!(
        :email => "realtwo@email.com",
        :description => "MyText",
        :cause => "Cause"
      )
    ])
  end

  it "renders a list of reports" do
    render
    expect(rendered).to have_content("real@email.com")
    expect(rendered).to have_content("Cause")
    expect(rendered).to have_content("realtwo@email.com")
  end
end
