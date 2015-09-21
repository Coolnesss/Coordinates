class ChangePositionUpdatesToText < ActiveRecord::Migration
  def change
    change_column :positions, :updates, :text
  end
end
