class AddIssueIdToPosition < ActiveRecord::Migration
  def change
    add_column :positions, :issue_id, :string
  end
end
