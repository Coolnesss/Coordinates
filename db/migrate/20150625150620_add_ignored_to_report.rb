class AddIgnoredToReport < ActiveRecord::Migration
  def change
    add_column :reports, :ignored, :boolean
  end
end
