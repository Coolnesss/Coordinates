class ChangeFbIdToEightByte < ActiveRecord::Migration
  def change
    change_column :positions, :fb_id, :bigint
  end
end
