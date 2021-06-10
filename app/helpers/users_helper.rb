module UsersHelper

  def current_user_is_admin?
    current_user.is_admin == true
  end

end
