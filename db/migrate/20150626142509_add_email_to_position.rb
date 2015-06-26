class AddEmailToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :email, :string
  end
end
