class SessionsController < ApplicationController
  before_action :get_user_by_email, only: [:create]
  before_action :authenticate?, only: [:create]

  def new
    redirect_with_flash("danger", "already_login", store_index_path) if current_user
  end

  def create
    if @user.confirm
      create_user(@user)
      redirect_to session[:feedback_url] ? session[:feedback_url] : store_index_path
    else
      redirect_with_flash("danger", "activate_your_account", store_index_path)
    end
  end

  def destroy
    logout_user if current_user
    redirect_to store_index_path
  end

  private

    def authenticate?
      redirect_with_flash("danger", "invalid_password", login_url) unless @user.authenticate(params[:password])
    end

    def get_user_by_email
      @user = User.find_by(email: params[:email])
      redirect_with_flash("danger", "email_not_found", login_url) unless @user
    end

    def create_user(user)
      session[:user_id] = user.id
      params[:remember_me] == 'on' ? remember_user(user) : forget_user(user)
    end

    def logout_user
      cookies.delete(:user_id)
      session.delete(:user_id)
      @current_user = nil
    end

    def remember_user(user)
      cookies.permanent.encrypted[:user_id] = user.id
    end

    def forget_user(user)
      cookies.delete(:user_id)
    end

end
