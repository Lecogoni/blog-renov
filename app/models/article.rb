class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  has_many_attached :images, dependent: :purge_later
  
  validates :images, presence: true


  def upcase_title
    title = self.title.upcase
  end

  def titleize_title
    title = self.title.titleize
  end

  # display on article#index or the first article images or the cover_img == true if it has one
  def display_cover_img
    @picture = []
    if self.images.any?{|pic| pic.cover_img == true}
      self.images.each do |pic|
        if pic.cover_img == true
          @picture << pic
        end
      end
    else
      @picture << self.images.first
    end
    return @picture.first
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
