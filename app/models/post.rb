class Post < ApplicationRecord
  belongs_to :user
  belongs_to :column
  validates :title, presence: true
  validates :body, presence: true
end
