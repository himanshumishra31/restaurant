class PasswordsController < ApplicationController
  before_action :get_user_by_email, only: [:create, :update]
  before_action :get_user_by_token, only: [:edit]
  before_action :email_verified?, only: [:create]
  before_action :reset_link_expired?, only: [:update]
  before_action :password_empty?, only: [:update]

  def create
    if @user
      @user.set_reset_password_token
      @user.send_password_reset_email
      redirect_with_flash("info", "password_reset_mail", store_index_path)
    end
  end

  def update
    if @user.update_attributes(user_params)
      @user.update_attribute(:reset_password_token, nil)
      redirect_with_flash("success", "new_password_saved", login_url)
    else
      render 'new'
    end
  end

  private

    def password_empty?
      if params[:user][:password].empty?
        @user.errors.add(:password, "can't be empty")
        render 'new'
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user_by_token
      @user = User.find_by(reset_password_token: params[:id])
      redirect_with_flash("danger", "already_used", store_index_path) unless @user
    end

    def get_user_by_email
      @user = User.find_by(email: params[:email])
      redirect_with_flash("danger", "email_not_found", new_password_url) unless @user
    end

    def email_verified?
      redirect_with_flash("danger", "email_not_verified", login_url) unless @user.confirm
    end

    def reset_link_expired?
      redirect_with_flash("danger", "reset_link_expired", new_password_url) if @user.password_reset_expired?
    end

end

