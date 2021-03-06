class LikesController < ApplicationController
  before_action :find_article

  def create

    if already_liked?
      flash[:alert] = "vous avez déjà Liké cette publication !"
    else
      @article.likes.create(user_id: current_user.id)
      flash[:success] = "Merci pour votre like !"
    end
    redirect_to article_path(@article)

    #@article.likes.create(user_id: current_user.id)
    #redirect_to article_path(@article)
  end

  private

  def find_article
    @article = Article.find(params[:article_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, article_id: params[:article_id]).exists?
  end

end
