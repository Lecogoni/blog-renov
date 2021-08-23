class GuestsController < ApplicationController
  before_action :set_guest, only: %i[ show edit update destroy ]
  before_action :downcase_fields, only: %i[ create update ]

  # GET /users or /users.json
  def index
    @guests = Guest.all.order("first_name ASC")
  end

  def show
  end

  def new
    @guest = Guest.new
  end

  def edit
  end


  def create

    if Guest.where(email: guest_params[:email]).count >= 1
      redirect_to root_path
      flash[:error] = "Votre demande ne peut aboutir. Une demande de création de compte est déjà enregistrée avec l'email : #{guest_params[:email]}"

    elsif User.where(email: guest_params[:email]).count >= 1
      redirect_to root_path
      flash[:error] = "Votre demande ne peut aboutir. Un compte est déjà enregistré avec l'email : #{guest_params[:email]}"
    
    else
      
      @guest = Guest.new(guest_params)
      
      respond_to do |format|
        if @guest.save
          # send a email to the new guest and website manager
          UserMailer.registration_email(@guest).deliver_now
          UserMailer.new_registration_member(@guest).deliver_now

          format.html { redirect_to root_path }
          flash[:success] = "Votre demande à bien été enregistrée. Une fois examinée par un membre de Rénov-Fauteuil vous recevrez par email un lien pour vous connecté et enregistrer votre mot de passe"
          format.json { render :show, status: :created, location: @guest }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @guest.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(guest_params)
        format.html { redirect_to @guest }
        flash.now[:success] = "Vos modififications ont bien été enregistrées"
        format.json { render :show, status: :ok, location: @guest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      flash.now[:success] = "User was successfully destroyed."
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def guest_params
      params.require(:guest).permit(:first_name, :last_name, :phone_number, :email)
    end

    # downcase some fields before saving in db
    def downcase_fields
      guest_params[:first_name].downcase!
      guest_params[:last_name].downcase!
      guest_params[:email].downcase!
    end

end
