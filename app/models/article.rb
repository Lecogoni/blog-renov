class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :parts, dependent: :destroy
  
  has_one_attached :header_image, dependent: :purge_later
  
  validates :header_image, presence: true

  #validate :header_image_rezise


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

  def header_image_rezise
    return unless header_image.attached?
    return unless header_image.content_type.start_with? 'image/'
    resized_image = MiniMagick::Image.read(header_image.download)
    resized_image = resized_image.resize "40x40"
    v_filename = header_image.filename
    v_content_type = header_image.content_type
    header_image.purge
    header_image.attach(io: File.open(resized_image.path), filename:  v_filename, content_type: v_content_type)
  end


end
