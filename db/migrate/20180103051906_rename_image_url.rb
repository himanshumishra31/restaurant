class RenameImageUrl < ActiveRecord::Migration[5.1]
  def change
    rename_column :meals, :image_url, :image
  end
end
