class UsersController < ApplicationController

  include UsersHelper
  
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index

    @users = User.all.order("first_name ASC")

    if params[:order] == 'name'
        @users = User.all.order("first_name ASC")
    elsif params[:order] == 'lastname'
        @users = User.all.order("last_name ASC")
    else
      @users = User.all.order("first_name ASC")
    end

  end

  # GET /users/1 or /users/1.json
  def show
    @articles = @user.articles.order("created_at DESC")
    @posts = @user.posts.order("created_at DESC")
    @guests = Guest.all.order("first_name ASC")
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Vos modififications ont bien été enregistrées" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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

  def delete_avatar_attachment
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back(fallback_location: request.referer)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :phone_number, :email, :avatar, :show_data)
    end
end
