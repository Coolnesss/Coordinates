class AddVotesToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :votes, :integer
  end
end
