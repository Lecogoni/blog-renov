class AddBooleanColumnToActiveStorageAttachment < ActiveRecord::Migration[6.1]
  def change
    add_column :active_storage_attachments, :cover_img, :boolean
  end
end
