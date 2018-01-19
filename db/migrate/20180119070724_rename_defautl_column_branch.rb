class RenameDefautlColumnBranch < ActiveRecord::Migration[5.1]
  def change
    rename_column :branches, :default_res, :default
  end
end
