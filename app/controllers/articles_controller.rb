class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy admin_delete_article]
  before_action :downcase_fields, only: %i[ create update ]
  before_action :check_cover_img_if_one_img, only: %i[ edit ]
  #after_action :picture_format, only: %i[ create update ]
  

  # GET /articles or /articles.json
  def index
    if params.has_key?(:category)
      @category = Category.find_by_name(params[:category])
      if Article.where(category: @category).count == 0
        @articles = Article.all.order("created_at DESC")
        flash.now[:notice] = "Aucune création dans la catégorie : #{params[:category]}. Voici l'ensemble des créations"
        params[:category] = nil
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
    @images = @article.images.order("created_at ASC")
    @comments = @article.comments.order("created_at ASC")
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @images = @article.images.order("created_at ASC")

    # Define first images as cover picture
    if @article.images.none?{|pic| pic.cover_img == true}
      puts "----------------$$$$$$$$$$$$$$$$$$$"
      puts "---------------- acune = true"
      puts 
      puts "----------------$$$$$$$$$$$$$$$$$$$"
      @image = @article.images.first
      @image.cover_img = true
      @image.save
      # ActiveStorage::Attachment.where(blob_id: img_first.id, record_type: 'Article').last
      
    end
  end

  # POST /articles or /articles.json
  def create

    @article = Article.new(article_params)

    if @article.save

      # check if there is ActiveStorage Attachement and if yes get them in @files which is then send to a method to delete files != image, and resize image
      if params[:article][:images].present?
        number_of_ActiveStorage_attachement = params[:article][:images].size
        @files = ActiveStorage::Attachment.where(record_id: @article.id, record_type: 'Article').last(number_of_ActiveStorage_attachement).reverse
        picture_format(@files)
      end
      
      redirect_to @article
      flash[:success] = "Votre article a été enregistré !"
    else
      render :new, status: :unprocessable_entity
      flash[:error] = "votre publication n'a pas été enregistrée"
    end

  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update

    @article.images.each do |image|
      image.cover_img = false
      image.save
    end

    img_id = params[:article][:img_id]

    if img_id != nil 
      attachment = ActiveStorage::Attachment.find(params[:article][:img_id])
      attachment.cover_img = true
      attachment.save
    end
    
    if @article.update(article_params)

      # check if there is ActiveStorage Attachement and if yes get them in @files which is then send to a method to delete files != image, and resize image
      if params[:article][:images].present?
        number_of_ActiveStorage_attachement = params[:article][:images].size
        @files = ActiveStorage::Attachment.where(record_id: @article.id, record_type: 'Article').last(number_of_ActiveStorage_attachement).reverse
        picture_format(@files)
      end

      redirect_to @article
      flash[:success] = "Votre article est bien modifié !"
    else
      render :edit, status: :unprocessable_entity
    end
    

  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    redirect_to articles_url
    flash[:success] = "L'article a été supprimé"
  end

  # allow to purge active storage files
  def delete_file
    file = ActiveStorage::Attachment.find(params[:id])
    @article_id = params[:article_id]
    file.purge
    redirect_back(fallback_location: edit_article_path(@article_id))
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
    params.require(:article).permit(:title, :description, :user_id, :category_id, images: [])
  end

  def downcase_fields
    article_params[:title].downcase!
  end

  # when user press on article edit it check if there is only one image, if yes it set image.cover_img to true
  def check_cover_img_if_one_img
    if @article.images.count == 1
      attachement = ActiveStorage::Attachment.where(record_id: @article.id, record_type: "Article").first
      attachement.cover_img = true
      attachement.save
    end
  end

  # check if blob is an image, if not delete the blob and send a message 
  # then if the image isn't a variable? it convert to jpeg
  def picture_format(files)
    puts "------******************************-----------"
    puts "------FILE SIZE-----------"
    puts files.size
    puts "----------------------"

    @files = files
    puts "----------------------"
    file_erased = 0
    @files.each do |file|
      # check if file / blob is an image - if not erase
      if ! file.content_type.start_with? 'image/'
        purge_none_image_file(file)
        file_erased += 1
      # if it's an image rezise, convert and upload
      else
        # file is a ActiveStorage::Attachment we convert in ActiveStorage::Blob
        blob = file.blob
        puts "------******************************-----------"
        puts "-----FILEVARIABLE ?-----------"
        puts blob.variable?

        blob.open do |tempfile| # temp_file
          path = tempfile.path #temp_file

          if ! image_blob_is_variable?(blob)
            puts "------******************************-----------"
            puts "-----DANS LA CONDITION -----------"
            pipeline = ImageProcessing::MiniMagick.source(path)
            .convert!("jpeg")
          end 

          pipeline = ImageProcessing::MiniMagick.source(path)
          .resize_to_limit(1200, 1200)
          .call(destination: path)
          
          new_data = File.binread(path)
          @article.send(:images).attach io: StringIO.new(new_data), filename: blob.filename.to_s, content_type: 'image/jpg'
        end
        file.purge_later
      end
    end
    return file_erased
  end

  def purge_none_image_file(file)
    file.purge
  end

  # if image blob isn't representable convert in appropriate format
  # avoid to get HEIC for e.g. - impossible to get a variant on content_type not true
  def image_blob_is_variable?(image)
    image.variable?
  end

end

