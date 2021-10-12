class RemoveCoverImgBooleanFromActiveStrorageAttachement < ActiveRecord::Migration[6.1]
  def change
    remove_column :active_storage_attachments, :cover_img, :boolean
  end
end
