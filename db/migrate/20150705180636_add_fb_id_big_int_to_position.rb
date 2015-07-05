class AddFbIdBigIntToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :fb_id, :bigint
  end
end
