class Position < ActiveRecord::Base
  validates :name, :description, :lon, :lat, presence: true

  validates :name, length: { maximum: 20 }
  validates :description, length: { maximum: 340 }
  validates_numericality_of :lon
  validates_numericality_of :lat

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "85x85>" }, :default_url => "null"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def date_format
    date = self.created_at
    date.day.to_s + "." + date.month.to_s + "." + date.year.to_s
  end

end
