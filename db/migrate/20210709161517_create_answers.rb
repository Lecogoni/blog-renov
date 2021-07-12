class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :body
      t.references :answerable, polymorphic: true, null: false
      t.references :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
