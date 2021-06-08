module UsersHelper

  def is_admin?
    current_user.is_admin == true
  end

end
