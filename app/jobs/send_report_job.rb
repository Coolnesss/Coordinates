class SendReportJob < ActiveJob::Base
  queue_as :default

  def perform(pos_id)
    IssueReporter.send pos_id
    Rails.cache.delete "issues"
  end
end
