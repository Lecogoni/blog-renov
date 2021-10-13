class CreateParts < ActiveRecord::Migration[6.1]
  def change
    create_table :parts do |t|
      t.string :element_type
      t.text :content
      t.references :article, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
