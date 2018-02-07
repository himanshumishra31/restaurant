class SessionsController < ApplicationController
  # FIX_ME_PG:- rename to `def check_for_valid_credentials`
  before_action :authenticate_user, only: [:create]

  def new
    redirect_with_flash("danger", "already_login", store_index_path) if current_user
  end

  def create
    # FIX_ME:- Also add a new before_action for checking confirmation `def check_for_confirmation`
    if @user.confirmed
      create_user(@user)
      redirect_to session[:feedback_url] ? session[:feedback_url] : store_index_path
    else
      redirect_with_flash("danger", "activate_your_account", store_index_path)
    end
  end

  def destroy
    logout_user if current_user
    # FIX_ME_PG:- Set flash message here.
    redirect_to store_index_path
  end

  private

    def authenticate_user
      @user = User.find_by(email: params[:email])
      redirect_with_flash("danger", "invalid_credentials", login_url) unless @user && @user.authenticate(params[:password])
    end

    #  FIX_ME:- Rename to login_user.
    def create_user(user)
      session[:user_id] = user.id
      # FIX_ME:- Why are we sending value in remember me?
      params[:remember_me] == 'on' ? remember_user(user) : forget_user(user)
    end

    def logout_user
      cookies.delete(:user_id)
      session.delete(:user_id)
      # FIX_ME:- Y are we setting nil to @current_user?
      @current_user = nil
    end

    def remember_user(user)
      cookies.permanent.encrypted[:user_id] = user.id
    end

    def forget_user(user)
      cookies.delete(:user_id)
    end

end
