class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.float :x
      t.float :y
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
