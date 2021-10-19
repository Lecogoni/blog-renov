
# From article Controller
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


# redirect from create articel controller to create
if number_of_images == 0
    flash[:alert] = "Votre article a été enregistré, cependant les fichiers uploadés ne sont pas au format images. Ils n'apparaîtrons pas"
  elsif number_of_files_uploaded - number_of_images == 1 
    flash[:alert] = "Votre article a été enregistré, cependant 1 fichier uploadé n'est pas au format image. Il n'apparaîtra pas"
  elsif number_of_files_uploaded - number_of_images > 1
    flash[:alert] = "Votre article a été enregistré, cependant #{number_of_files_uploaded - number_of_images}  fichiers uploadés ne sont pas au format image. Ils n'apparaîtront pas"
  else
    flash[:success] = "Votre article a été enregistré !"
  end

  # -------------------------------------------------------------------------------------------
  # FROM article# update

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



# -------------------------------------------------------------------------------------------
# PRIVATE METHOD IN ARTICLE CONTROLLER

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

  # purge active storage attachement
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

  # --------------------------------------------------------------

  <!--<%= render 'carousel', article: @article %>-->

  # --------------------------------------------------------------
  # FROM article form

  <% if @article.images.attached? %>
    <div class="row mb-2">
      <% @images.each do |image| %>
        <div class="col-6 col-xs-6 col-sm-6 col-md-4 col-lg-4 col-xl-4">
            <div class="card-edit-img">
              <div class="card-content">
                <%= image_tag image, class: "img-fluid mb-2" %> 
                <div class="d-flex flex-column align-items-center img-data">
                  <div>
                    <span><%= f.radio_button:img_id, image.id, :checked => (image.cover_img == true), required: true  %> image principale</span><br>
                  </div>
                  <div>
                    <span><%= link_to 'supprimer', delete_file_article_path(image.id, article_id: @article.id), method: :delete, class: 'delete-img', confirm: 'Êtes vous certain de vouloir supprimer cette image ?'  %></span>
                  </div>
                  <div>
                  </div>
                </div>
              </div>
            </div>
        </div>
      <% end %>
    </div>
  <% end %>




