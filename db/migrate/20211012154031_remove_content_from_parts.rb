class RemoveContentFromParts < ActiveRecord::Migration[6.1]
  def change
    remove_column :parts, :content
  end
end
