module PostsHelper

  # return a centered crop landscape picture if picture is portrait
  def crop_portrait_post_picture(image)
    # return true if picture mode is portrait (heigth > width )
    width = image.blob.metadata[:width].to_i
    height = image.blob.metadata[:height].to_i
    if  width < height
      return image.variant(resize: "300x225^", gravity: "center", crop: "300x225+0+0")
    else 
      return image
    end   
  end


end
