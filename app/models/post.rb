class Post < ApplicationRecord
  belongs_to :user
  belongs_to :column

  has_one_attached :picture, dependent: :purge_later

  has_many :answers, as: :answerable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true


  def display_created_at
    create = created_at.strftime("%d %B %Y")
  end

end
