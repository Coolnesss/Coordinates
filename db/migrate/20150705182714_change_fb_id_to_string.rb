class ChangeFbIdToString < ActiveRecord::Migration
  def change
    change_column :positions, :fb_id, :string
  end
end
