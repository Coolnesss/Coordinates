class AddAttachmentImageToPositions < ActiveRecord::Migration
  def self.up
    change_table :positions do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :positions, :image
  end
end
