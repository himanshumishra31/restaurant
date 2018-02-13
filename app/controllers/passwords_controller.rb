class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :get_user_by_email, only: [:create, :update]
  before_action :get_user_by_token, only: [:edit]
  before_action :check_for_confirmed_email, only: [:create]
  before_action :check_for_expired_link, only: [:update]
  before_action :check_for_empty_password, only: [:update]

  def create
    # to discuss. If we do this in after create callback then it will also run when we will create a new user.
    @user.set_reset_password_token
    @user.send_password_reset_email
    redirect_with_flash("info", "password_reset_mail", store_index_path)
  end

  def update
    if @user.update_attributes(user_params)
      redirect_with_flash("success", "new_password_saved", login_url)
    else
      render :edit
    end
  end

  private

    def check_for_empty_password
      if params[:user][:password].empty?
        @user.errors.add(:password, "can't be empty")
        render :edit
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

    def check_for_confirmed_email
      redirect_with_flash("danger", "email_not_verified", login_url) unless @user.confirmed
    end

    def check_for_expired_link
      redirect_with_flash("danger", "reset_link_expired", new_password_url) if @user.reset_password_token_expired?
    end

end
