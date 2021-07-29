class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy admin_delete_post ]

  # GET /posts or /posts.json
  def index
    


    if params.has_key?(:column)
      @column = Column.find_by_name(params[:column])
      if Post.where(column: @column).count == 0
        @posts = Post.all.order("created_at DESC")
        flash.now[:notice] = "Aucune annonce dans la catégorie : #{params[:column]}. Voici l'ensemble des annonces"
        params[:column] = nil
      else
        @posts = Post.where(column: @column).order("created_at DESC")
      end
      #@articles = Article.where(category: @category).order("created_at DESC")
    else
      @posts = Post.all.order("created_at DESC")
    end

  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path }
        flash[:success] = "Votre annonce est bien enregistrée"
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post }
        flash[:success] = "Votre annonce a correctement été modifiée"
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      flash[:success] = "votre annonce a bien été supprimée" 
      
      format.json { head :no_content }
    end
  end

  def admin_delete_post
    UserMailer.admin_delete_post_email(@post).deliver_now
    @post.destroy
    redirect_to posts_url
    flash[:alert] = "Cette annonce a été supprimé. Un email a été envoyé à son créateur pour l'en avertir"     
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :user_id, :column_id, :picture)
    end
end
