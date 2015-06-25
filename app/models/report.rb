class Report < ActiveRecord::Base
  validates :email, :email => true
  validates :description, presence: true
  validates :cause, presence: true
  validates :position, presence: true

  belongs_to :position

  def ignore
    self.ignored = true
    self.save
  end
end
