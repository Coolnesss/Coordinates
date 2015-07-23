class AddCategoryToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :category, :integer
  end
end
