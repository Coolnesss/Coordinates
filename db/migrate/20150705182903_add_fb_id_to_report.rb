class AddFbIdToReport < ActiveRecord::Migration
  def change
    add_column :reports, :fb_id, :string
  end
end
