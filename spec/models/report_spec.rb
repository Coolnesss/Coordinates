require 'rails_helper'

describe Report do
  it "Can save a valid report" do
    FactoryGirl.create(:report)
    expect(Report.count).to eq(1)
  end

  it "Cannot save a report with an invalid email" do
    report = Report.create(cause: "legit", description: "legit", email: "not legit")
    expect(report).not_to be_valid
    expect(Report.count).to eq(0)
  end

  it "Cannot save a report without an email" do
    report = Report.create(cause: "legit", description: "real")
    expect(report).not_to be_valid
  end

  it "Cannot save a report without a position" do
    report = Report.create(
      cause: "legit",
      description: "real",
      email:"real@real.fi",
    )
    expect(report).not_to be_valid
  end
end
