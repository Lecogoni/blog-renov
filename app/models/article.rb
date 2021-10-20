class Article < ApplicationRecord

  require "mini_magick"

  belongs_to :user
  belongs_to :category

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :parts, dependent: :destroy
  
  has_one_attached :header_image, dependent: :purge_later
  
  validates :header_image, presence: true


  def upcase_title
    title = self.title.upcase
  end

  def titleize_title
    title = self.title.titleize
  end

  def article_has_like?
    self.likes.count >= 1
  end

  def who_likes_article
    @likes = self.likes.to_a
    @liker = []
    @likes.each do |like|
      @liker << like.user.full_name
    end
    return @liker.join(", ")
  end


end
