class CommentsController < ApplicationController
  before_action :set_article
  before_action :comment_params

  def create

    @comment = @article.comments.new(comment_params)

    if @comment.save
      redirect_to @article, notice: 'Merci, votre commentaire a bien été ajouté.'
    end

  end

  def destroy
  end

  private
   
  def set_article
   @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

end
