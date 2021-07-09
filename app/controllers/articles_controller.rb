class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy admin_delete_article]

  # GET /articles or /articles.json
  def index
    if params.has_key?(:category)
      @category = Category.find_by_name(params[:category])
      if Article.where(category: @category).count == 0
        @articles = Article.all.order("created_at DESC")
        flash.now[:notice] = "Il n'y a aucune création enregistrées dans cette catégorie"
      else
        @articles = Article.where(category: @category).order("created_at DESC")
      end
      #@articles = Article.where(category: @category).order("created_at DESC")
    else
      @articles = Article.all.order("created_at DESC")
    end
    # @last_articles = Article.order("created_at DESC").first(2)
  end

  # GET /articles/1 or /articles/1.json
  def show
    @other_articles = Article.where(user_id: @article.user_id).where.not(id: @article.id)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create

    
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Votre article a été enregistré !"
    else
      render :new, status: :unprocessable_entity 
    end

  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update

    if @article.update(article_params)

      redirect_to @article, notice: "Votre article est modifié !"
    else
      render :edit, status: :unprocessable_entity
    end

  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    redirect_to articles_url, notice: "L'article a été supprimer"
  end

  # allow to purge active storage files
  def delete_file
    file = ActiveStorage::Attachment.find(params[:id])
    file.purge
    redirect_back(fallback_location: articles_path)
  end

  def admin_delete_article
    UserMailer.admin_delete_article_email(@article).deliver_now
    @article.destroy
    redirect_to articles_url, notice: "Cet publication a été supprimé. Un email a été envoyé à son créateur pour l'en avertir"    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :description, :user_id, :category_id, images: [])
    end
end
