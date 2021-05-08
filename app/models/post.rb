class Post < ApplicationRecord
  belongs_to :user
  belongs_to :column
  validates :title, presence: true
  validates :body, presence: true


  def display_created_at
    create = created_at.strftime("%d %B %Y")
  end

end
