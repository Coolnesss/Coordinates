class Picture < ActiveRecord::Base

  belongs_to :position

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "85x85>" }, :default_url => "null"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
