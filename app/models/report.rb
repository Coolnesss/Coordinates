class Report < ActiveRecord::Base
  validates :email, :email => true
  validates :description, presence: true
  validates :cause, presence: true
end
