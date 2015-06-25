class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :email
      t.text :description
      t.string :cause

      t.timestamps null: false
    end
  end
end
