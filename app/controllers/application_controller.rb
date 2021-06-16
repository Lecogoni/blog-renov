class ApplicationController < ActionController::Base

  before_action :set_locale
  
  # change devise redirect after login
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access Denied' unless current_user.is_admin == true
  end
  
  private

  def set_locale
    I18n.locale = params[:fr] || I18n.default_locale
  end 

end
