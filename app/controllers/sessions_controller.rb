class SessionsController < ApplicationController
  before_action :get_user, only: [:find_user_by_email, :update_user_new_password, :get_user_new_password, :create]
  before_action :email_verified?, only: [:find_user_by_email]
  before_action :reset_link_expired?, only: [:update_user_new_password]
  before_action :password_empty?, only: [:update_user_new_password]

  def create
    if @user.authenticate(params[:password])
      if @user.email_confirmed
        create_user(@user)
      else
        flash_message("danger", "activate_your_account")
        redirect_to new_user_url
      end
    else
      flash_message("danger", "invalid_password")
      redirect_to login_url
    end
  end

  def find_user_by_email
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash_message("info", "password_reset_mail")
      redirect_to login_url
    end
  end

  def update_user_new_password
    if @user.update_attributes(user_params)
      @user.update_attribute(:reset_digest, nil)
      flash_message("success", "new_password_saved")
      redirect_to login_url
    else
      render 'get_user_new_password'
    end
  end


  def destroy
    logout_user if @current_user
    redirect_to login_url
  end

  private
    def password_empty?
      if params[:user][:password].empty?
        @user.errors.add(:password, "can't be empty")
        render 'get_user_new_password'
      end
    end

    def get_user
      @user = User.find_by(email: params[:email])
      unless @user
        flash_message("danger", "email_not_found")
        redirect_to login_url
      end
    end

    def email_verified?
      unless (@user.email_confirmed)
        flash_message("danger", "email_not_verified")
        redirect_to login_url
      end
    end

    def reset_link_expired?
      if @user.password_reset_expired?
        flash_message("danger", "reset_link_expired")
        redirect_to reset_password_url
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def create_user(user)
      session[:user_id] = user.id
      params[:remember_me] == 'on' ? remember_user(user) : forget_user(user)
      redirect_to new_user_path
    end
end
