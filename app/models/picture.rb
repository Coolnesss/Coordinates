class Picture < ActiveRecord::Base

  belongs_to :position

  has_attached_file :image,
    source_file_options: { all: '-auto-orient' },
    :styles => {:original => "2000x2000>", :medium => "300x300>", :thumb => "85x85>" },
    :default_url => "null"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
