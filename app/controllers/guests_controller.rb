class GuestsController < ApplicationController
  before_action :set_guest, only: %i[ show edit update destroy ]

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
      redirect_to root_path, notice: "Votre demande ne peut aboutir. Une demande de création de compte est déjà enregistrée avec l'email : #{guest_params[:email]}"

    elsif User.where(email: guest_params[:email]).count >= 1
      redirect_to root_path, notice: "Votre demande ne peut aboutir. Un profil est déjà enregistrée avec l'email : #{guest_params[:email]}"
    
    else
      @guest = Guest.new(guest_params)
      
      respond_to do |format|
        if @guest.save
          # send a email to the new guest
          UserMailer.registration_email(@guest).deliver_now

          format.html { redirect_to root_path, notice: "Votre demande à bien été enregistré. Une fois examiné par .... vous recevrez par email un lien pour vous connecté et enregistrer votre mot de passe" }
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
        format.html { redirect_to @guest, notice: "Vos modififications ont bien été enregistrées" }
        format.json { render :show, status: :ok, location: @guest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
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


end
