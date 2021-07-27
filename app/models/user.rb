class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_one_attached :avatar, dependent: :purge_later
  
  def full_name
    full_name = [first_name.capitalize, last_name.capitalize].join(' ')
  end

  def guest_request?
    Guest.all.count != 0
  end

  def user_pluralize_article
    num = self.articles.count
    num > 1 ? "#{num} creations" : "#{num} creation"
  end

  def user_pluralize_post
    num = self.articles.count
    num > 1 ? "#{num} annonces" : "#{num} annonce"
  end

  def user_publishing
    @articles = self.articles
    @posts = self.posts

    @creation = "#{@articles.count} création".pluralize if @articles.count != 1
    @annonce = @posts.count != 1 ? "#{@posts.count} annonces" : "#{@posts.count} annonce"
    
    "#{} annonce"

    if @articles.count == 0 && @posts.count == 0
      return "aucune publication"
      
    elsif @articles.count > 0 && @posts.count == 0
      return @creation.to_s

    elsif @articles.count == 0 && @posts.count > 0
      return @annonce.to_s

    elsif @articles.count > 0 && @posts.count > 0
      return "#{@creation} et #{@annonce}"
    end
  end

end
