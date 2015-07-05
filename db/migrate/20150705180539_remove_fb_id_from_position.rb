class RemoveFbIdFromPosition < ActiveRecord::Migration
  def change
    remove_column :positions, :fb_id, :integer
  end
end
