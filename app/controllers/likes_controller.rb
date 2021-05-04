class LikesController < ApplicationController
  before_action :find_post

  def create

    if already_liked?
      flash[:notice] = "vous ne pouvez Liké qu'une seul fois !"
    else
      @article.likes.create(user_id: current_user.id)
      flash[:notice] = "Merci pour votre like !"
    end
    redirect_to article_path(@article)

    #@article.likes.create(user_id: current_user.id)
    #redirect_to article_path(@article)
  end

  private

  def find_post
    @article = Article.find(params[:article_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, article_id: params[:article_id]).exists?
  end

end
