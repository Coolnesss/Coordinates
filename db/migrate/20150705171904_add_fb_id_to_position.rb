class AddFbIdToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :fb_id, :integer
  end
end
