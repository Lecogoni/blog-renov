class AddPublisedAndPublishedAtPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :published, :boolean
    add_column :posts, :published_at, :datetime
  end
end
