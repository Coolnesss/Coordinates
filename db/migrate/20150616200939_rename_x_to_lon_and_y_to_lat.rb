class RenameXToLonAndYToLat < ActiveRecord::Migration
  def change
    rename_column :positions, :x, :lon
    rename_column :positions, :y, :lat
  end
end
