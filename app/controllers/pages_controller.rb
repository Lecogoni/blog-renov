class PagesController < ApplicationController

  include PagesHelper

  def admin
    @guests = Guest.all.order("first_name ASC")
    @users = User.all.order("first_name ASC")

    # for filter on member list
    @users = User.all.order("first_name ASC")

    if params[:order] == 'name'
        @users = User.all.order("first_name ASC")
    elsif params[:order] == 'lastname'
        @users = User.all.order("last_name ASC")
    else
      @users = User.all.order("first_name ASC")
    end

    @categories = Category.all.order("name ASC")

  end

  def about
  end

  def confirm_guest_to_user
    # create new user
    @guest = Guest.find(params[:id])
    @new_user = User.create(first_name: @guest.first_name, last_name: @guest.last_name, email: @guest.email, phone_number: @guest.phone_number, password: "000000" )
    
    # generating a devise reset password token
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)

    user = User.find_by(email: @new_user.email)
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
    
    # destroy guest, redirect, email new user
    @guest.destroy
    redirect_to pages_admin_path, notice: "demande d'invitation validée ! #{@guest.first_name} a été notifié par email"
    UserMailer.confirm_registration_member(user, raw).deliver_now
  end

  def refuse_guest
    @guest = Guest.find(params[:id])
    UserMailer.refuse_guest_registration(@guest).deliver_now
    @guest.destroy
    redirect_to pages_admin_path
  end


end
