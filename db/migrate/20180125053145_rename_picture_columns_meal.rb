class RenamePictureColumnsMeal < ActiveRecord::Migration[5.1]
  def change
    change_table :meals do |t|
      t.rename :picture_file_name, :image_file_name
      t.rename :picture_content_type, :image_content_type
      t.rename :picture_file_size, :image_file_size
      t.rename :picture_updated_at, :image_updated_at
    end
  end
end
