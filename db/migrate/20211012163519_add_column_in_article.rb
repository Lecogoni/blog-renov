class AddColumnInArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :published, :boolean
    add_column :articles, :published_at, :datetime
  end
end
