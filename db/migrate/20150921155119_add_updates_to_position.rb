class AddUpdatesToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :updates, :string
  end
end
