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
    article_num = self.articles.count
    article_published_num = self.articles.where("published = true").count
    if article_num == 0
        return 'aucune création'
    elsif article_num != 0 && article_num != article_published_num
        if article_published_num == 1
            article_num > 1 ? "#{article_num} articles, dont #{article_published_num} publié" : "#{article_num} article, dont #{article_published_num} publié"
        else
            article_num > 1 ? "#{article_num} articles, dont #{article_published_num} publiés" : "#{article_num} article, dont #{article_published_num} publiés"
        end
    elsif article_num != 0 && article_num == article_published_num
        return article_num > 1 ? "#{article_num} articles publiés" : "#{article_num} article publié"
    end
    
  end

  def user_pluralize_post
    num = self.posts.count
    if num == 0
        return 'aucune annonce'
    else
        return num > 1 ? "#{num} annonces" : "#{num} annonce"
    end
  end


  # ==> voir si cette methode est utilisé
  def user_publishing
    @articles_published = self.articles.where("published = true")
    @posts = self.posts

    @creation = @articles_published.count != 1 ? "#{@articles_published.count} articles publiés" : "#{@articles_published.count} article publié"
    @annonce = @posts.count != 1 ? "#{@posts.count} annonces" : "#{@posts.count} annonce"


    if @articles_published.count == 0 && @posts.count == 0
      return "aucune publication"
      
    elsif @articles_published.count > 0 && @posts.count == 0
      return @creation.to_s

    elsif @articles_published.count == 0 && @posts.count > 0
      return @annonce.to_s

    elsif @articles_published.count > 0 && @posts.count > 0
      return "#{@creation} et #{@annonce}"
    end
  end

end
