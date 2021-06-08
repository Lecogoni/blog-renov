class AddNewColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :show_data, :boolean, default: false
  end
end
