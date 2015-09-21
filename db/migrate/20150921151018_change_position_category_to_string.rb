class ChangePositionCategoryToString < ActiveRecord::Migration
  def change
    change_column :positions, :category, :string
  end
end
