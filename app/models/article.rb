class Article < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  def upcase_title
    title = self.title.upcase
  end

  def titleize_title
    title = self.title.titleize
  end

end
