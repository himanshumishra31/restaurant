class SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :check_for_valid_credentials, only: [:create]
  before_action :check_for_confirmation, only: [:create]

  def new
    if @current_user
      redirect_with_flash("danger", "already_login", store_index_path)
    end
  end

  def create
    create_user(@user)
    redirect_to session[:feedback_url] ? session[:feedback_url] : store_index_path
  end

  def destroy
    logout_user if @current_user
    redirect_with_flash("success", "logged_out", store_index_path)
  end

  private

    def check_for_valid_credentials
      @user = User.find_by(email: params[:email])
      unless @user && @user.authenticate(params[:password])
        redirect_with_flash("danger", "invalid_credentials", login_url)
      end
    end

    def check_for_confirmation
      unless @user.confirmed
        redirect_with_flash("danger", "activate_your_account", store_index_path)
      end
    end

    def create_user(user)
      session[:user_id] = user.id
      params[:remember_me] ? remember_user(user) : forget_user(user)
    end

    def logout_user
      cookies.delete(:user_id)
      session.delete(:user_id)
    end

    def remember_user(user)
      cookies.permanent.encrypted[:user_id] = user.id
    end

    def forget_user(user)
      cookies.delete(:user_id)
    end

end
