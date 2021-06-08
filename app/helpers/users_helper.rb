module UsersHelper

  def is_admin?
    current_user.is_admin == true
  end
  
  def show_data?
    self.show_data == true
  end

end
