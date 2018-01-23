class RenameColumnsBranches < ActiveRecord::Migration[5.1]
  def change
    rename_column :branches, :contact, :contact_number
  end
end
