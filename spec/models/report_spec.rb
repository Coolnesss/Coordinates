require 'rails_helper'

describe Report do
  it "Can save a valid report" do
    FactoryGirl.create(:report)
    expect(Report.count).to eq(1)
  end

  it "Cannot save a report with an invalid email" do
    report = FactoryGirl.build(:report, email: "not legit")
    report.save

    expect(report).not_to be_valid
    expect(Report.count).to eq(0)
  end

  it "Cannot save a report without an email" do
    report =  FactoryGirl.build(:report, email: nil)
    report.save

    expect(report).not_to be_valid
    expect(Report.count).to eq(0)
  end

  it "Cannot save a report without a position" do
    report = FactoryGirl.build(:report, position: nil)
    report.save

    expect(report).not_to be_valid
    expect(Report.count).to eq(0)
  end
end
