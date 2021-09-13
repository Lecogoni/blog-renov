class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy admin_delete_article]
  before_action :downcase_fields, only: %i[ create update ]
  after_action :define_first_img_as_cover_img, only: %i[ create ]
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
  end

  # POST /articles or /articles.json
  def create

    @article = Article.new(article_params)

    if @article.save

      # check if there is ActiveStorage Attachement and if yes get them in @files which is then send to a method to delete files != image, and resize image
      if params[:article][:images].present?
        number_of_ActiveStorage_attachement = params[:article][:images].size
        @files = ActiveStorage::Attachment.where(record_id: @article.id, record_type: 'Article').last(number_of_ActiveStorage_attachement).reverse
        number_of_files_uploaded = @files.length
        @images = upload_file_is_image?(@files)
        number_of_images = @images.length
        if number_of_images > 0
          picture_format(@images)
        end
      end
      
      redirect_to @article
      if number_of_images == 0
        flash[:alert] = "Votre article a été enregistré, cependant les fichiers uploadés ne sont pas au format images. Ils n'apparaîtrons pas"
      elsif number_of_files_uploaded - number_of_images == 1 
        flash[:alert] = "Votre article a été enregistré, cependant 1 fichier uploadé n'est pas au format image. Il n'apparaîtra pas"
      elsif number_of_files_uploaded - number_of_images > 1
        flash[:alert] = "Votre article a été enregistré, cependant #{number_of_files_uploaded - number_of_images}  fichiers uploadés ne sont pas au format image. Ils n'apparaîtront pas"
      else
        flash[:success] = "Votre article a été enregistré !"
      end
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

      number_of_img_uploaded = 0
      # check if there is ActiveStorage Attachement and if yes get them in @files which is then send to a method to delete files != image, and resize image

      if params[:article][:images].present?
        number_of_ActiveStorage_attachement = params[:article][:images].size
        @files = ActiveStorage::Attachment.where(record_id: @article.id, record_type: 'Article').last(number_of_ActiveStorage_attachement).reverse
      
        #puts "------******************************----------- ------******************************----------- ------******************************-----------"
        # puts "------******************************----------- ------******************************----------- ------******************************-----------"
        # puts "@files : #{@files}" 
        # puts "@files.class : #{@files.class}"
        # puts "------FILES SIZE BEFORE ERASE-----------"
    
 

        # erased no image


        # puts "------FILE SIZE AFTER ERASE-----------"

        numbFiles = @files.length.to_i
        @images = upload_file_is_image?(@files)
        numbImg = @images.length.to_i
        #puts "number_of_images =  : #{numbFiles}"
        number_of_img_uploaded = numbFiles - numbImg
        puts "variable = #{number_of_img_uploaded}"
        # puts "number_of_images : #{number_of_images}"
        #picture_format(@images)
        if @images.length > 0
          picture_format(@images)
        end
      end
      
      puts "variable = #{number_of_img_uploaded}"

      redirect_to @article
      
      if !params[:article][:images].present?
        flash[:success] = "Votre article est bien modifié !"
      elsif numbFiles === numbImg
        flash[:success] = "Votre article est bien modifié !"
      elsif numbFiles != numbImg

        if number_of_img_uploaded == 1
          flash[:alert] = "Votre article a été modifié, cependant 1 fichier uploadé n'est pas au format image. Il n'apparaîtra pas"
        elsif number_of_img_uploaded > 1
          flash[:alert] = "Votre article a été modifié, cependant #{numbFiles - numbImg} fichiers uploadés ne sont pas au format images. Ils n'apparaîtrons pas"
        end

      end

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

  # after_create : set first image as cover image
  def define_first_img_as_cover_img
    if @article.images.count > 0
      attachement = ActiveStorage::Attachment.where(record_id: @article.id, record_type: "Article").first
      attachement.cover_img = true
      attachement.save
    end
  end

  # check if an uploaded file is a image - if not send to be purge - count the number of files purged
  def upload_file_is_image?(files)
    files.each do |file|
      if !file.content_type.start_with? 'image/'
        purge_file(file)
        files.delete file
      end
    end
    return files
  end

  # purge actoive storage attachement
  def purge_file(file)
    file.purge_later
  end


  # if image blob isn't representable convert in appropriate format
  # avoid to get HEIC for e.g. - impossible to get a variant on content_type not true
  def image_blob_is_variable?(images)
    images.each do |image|
      if !image.variable?
        puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
        puts "IMAGE NOT VARIABLE"
        puts image.variable?
        blob = image.blob
        puts image.filename
        image.filename = "image"
        puts image.filename
      end

    end
    return images
  end

  # Resize image which whdth or height is superior or equal to my resize_size
  def picture_format(images)
    resize_size = 900
    puts "------******************************-----------"
    puts "------IN PICTURES FORMAT-----------"

    #puts "images.length #{images.length}"
    #puts "images.class #{images.class}"

    #puts "------        -----------"

      images.each do |image|
        meta = ActiveStorage::Analyzer::ImageAnalyzer.new(image).metadata
        #puts "image : #{image}"
        #puts "image.class : #{image.class}"
        if meta[:width] >= resize_size || meta[:height] >= resize_size   
          blob = image.blob
          #puts "blob : #{blob}"
          #puts "blob.class : #{blob.class}"
          blob.open do |picture|
            #puts pic
            #puts pic.class
            #puts pic.path


            ImageProcessing::MiniMagick.source(picture.path)
              .resize_to_limit(resize_size, resize_size)
              .quality(80)
              .call(destination: picture.path) #picture seulement marche aussi
            new_data = File.binread(picture.path)
            @article.send(:images).attach io: StringIO.new(new_data), filename: blob.filename.to_s, content_type: 'image'
            image.purge
          end
        end

      end
    



        # blob.open do |picture|
        #   puts "------PICTURES PATH -----------"
        #   path = picture.path
        #   puts picture.path
        #   ImageProcessing::MiniMagick.source(path)
        #     .resize_to_limit(1200, 1200)
        #     .call(destination: path)
        #   new_data = File.binread(path)
        #   @article.send(:images).attach io: StringIO.new(new_data), filename: blob.filename.to_s, content_type: 'image'
        #   puts "----------------------------------"
        # end
        #image.purge_later 

        # blob.open do |temp_file| # temp_file
        #   path = temp_file.path #temp_file

        #   if ! image_blob_is_variable?(blob)
        #     puts "------******************************-----------"
        #     puts "-----DANS LA CONDITION -----------"
        #     pipeline = ImageProcessing::MiniMagick.source(path)
        #     .convert!("jpeg")
        #   end 

        #   pipeline = ImageProcessing::MiniMagick.source(path)
        #   .resize_to_limit(1200, 1200)
        #   .call(destination: path)
          
        #   new_data = File.binread(path)
        #   @article.send(:images).attach io: StringIO.new(new_data), filename: blob.filename.to_s, content_type: 'image/jpg'
        # end

        # image.purge #purge_later 
    #end

  end




end

