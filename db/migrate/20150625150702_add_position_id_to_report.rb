class AddPositionIdToReport < ActiveRecord::Migration
  def change
    add_column :reports, :position_id, :integer
  end
end
