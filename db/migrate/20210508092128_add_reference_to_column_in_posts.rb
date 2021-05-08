class AddReferenceToColumnInPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :column, null: false, foreign_key: true
  end
end
