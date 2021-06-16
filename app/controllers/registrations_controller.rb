class RegistrationsController < Devise::RegistrationsController
  before_action :downcase_fields, only: %i[ create ]
  before_action :authorize_admin
  prepend_before_action :require_no_authentication, only: [:new, :cancel]

  def new
    super
  end

  def create

    @user = User.new(user_params)

    puts "-----------"
    puts "create"
    puts @user.first_name
    puts "-----------"

    respond_to do |format|
      if @user.save
        format.html { redirect_to pages_admin_path, notice: "le compte de #{@user.first_name.capitalize} a bien été créé. Un email avec l'ensemble des informations lui a été envoyé" }
        #format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :avatar, :show_data, :password)
  end

  def downcase_fields
    user_params[:first_name].downcase!
    user_params[:last_name].downcase!
    user_params[:email].downcase!
  end

end
