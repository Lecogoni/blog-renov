module UsersHelper

  def current_user_is_admin?
    current_user.is_admin == true
  end

  # display user.avatar or a defult one if he hasn't one
  def avatar_for(user)
    user.avatar.attached? ? user.avatar : asset_path("default-avatar.jpg")
  end
 


end
