
class ArticlesController < ApplicationController
    before_action :set_article, only: %i[ show edit update destroy return_to_article admin_delete_article]
    before_action :downcase_fields, only: %i[ create update ]
    before_action :delete_empty_part, only: %i[ return_to_article update ]
    
    #after_action :define_first_img_as_cover_img, only: %i[ create ]
    #after_action :picture_format, only: %i[ create update ]
    

    # GET /articles 
    def index
        
    if params.has_key?(:category)
        @category = Category.find_by_name(params[:category])
        if Article.where("published = true").where(category: @category).count == 0
            @articles = Article.all.order("created_at DESC").where("published = true")
            flash.now[:notice] = "Aucune création dans la catégorie : #{params[:category]}. Voici l'ensemble des créations"
            params[:category] = nil
        else
            @articles = Article.where("published = true").where(category: @category).order("created_at DESC")
        end
        #@articles = Article.where(category: @category).order("created_at DESC")
    else
        @articles = Article.where("published = true").order("created_at DESC")
    end
    
    end

    # GET /articles/
    def show
        @article_parts = Part.where(article_id: @article.id).order("position ASC")
        @other_articles = Article.where("published = true").where(user_id: @article.user_id).where.not(id: @article.id)
        
        @comments = @article.comments.order("created_at ASC")
        @last_articles = Article.order("created_at DESC").first(2)
    end

    # GET /articles/new
    def new
        @article = Article.new
    end

    # GET /articles/1/edit
    def edit
    #@images = @article.images.order("created_at ASC")    
        @element= @article.parts.build
    end

    # POST /articles
    def create

        @article = Article.new(article_params)

        if @article.save
            redirect_to @article
        else
            render :new, status: :unprocessable_entity
            flash[:error] = "votre publication n'a pas été enregistrée"
        end

    end

    # PATCH/PUT /articles/1 or /articles/1.json
    def update

       
    
        if @article.update(article_params)
            redirect_to @article
        else
            render :edit, status: :unprocessable_entity
        end
    end

    # DELETE articles
    def destroy
        @article.destroy
        redirect_to articles_url
        flash[:success] = "L'article a été supprimé"
    end

    # allow to purge active storage files
#   def delete_file
#     file = ActiveStorage::Attachment.find(params[:id])
#     @article_id = params[:article_id]
#     file.purge
#     redirect_back(fallback_location: edit_article_path(@article_id))
#   end


    def return_to_article
        redirect_to @article
    end

    def admin_delete_article
    UserMailer.admin_delete_article_email(@article).deliver_now
    @article.destroy
    redirect_to articles_url
    flash[:alert] = "Cette publication a été supprimé. Un email a été envoyé à son créateur pour l'avertir"  
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_article
        @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
        params.require(:article).permit(:user_id, :title, :description, :category_id, :header_image)
    end

    def downcase_fields
        article_params[:title].downcase!
    end

    # If user cancel edit or confirm update, this method delete empty parts - paragrapph or image
    def delete_empty_part

        @article.parts.each do |part|
            if part.element_type === 'paragraph' && part.content.empty?
                part.destroy
            elsif part.element_type === 'image' && part.image.attached? == false
                part.destroy
            end
        end

    end

end

