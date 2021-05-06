class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def upcase_title
    title = self.title.upcase
  end

  def titleize_title
    title = self.title.titleize
  end

end
