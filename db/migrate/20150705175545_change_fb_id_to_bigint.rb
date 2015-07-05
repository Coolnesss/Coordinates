class ChangeFbIdToBigint < ActiveRecord::Migration
  def change
    change_column :positions, :fb_id, :int, :limit => 8
  end
end
