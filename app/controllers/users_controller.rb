class UsersController < ApplicationController
  before_action :authorize, only: [:edit, :update]
  before_action :validate_user, only: [:show, :edit, :update]
  before_action :load_user, only: [:confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      redirect_with_flash("success", "confirm_email", login_url)
    else
      render 'new'
    end
  end

  def confirm_email
    @user.activate_email
    redirect_with_flash("success", "email_confirmed", login_url)
  end

  def update
    if @user.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", store_index_url)
    else
      render 'edit'
    end
  end

  def myorders
    @orders = current_user.orders
  end

  def feedback
    @user = User.find_by(verify_digest: params[:id])
  end

  private

    def link_expired?
      redirect_with_flash("danger", "link_expired", store_index_path) if @user.feedback_link_expired?
    end

    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def validate_user
      @user = User.find(session[:user_id])
      redirect_with_flash("danger", "other_account", login_url) unless @user == current_user
    end

    def load_user
      @user = User.find_by(confirm_token: params[:id])
      redirect_with_flash("danger", 'user_not_exist', new_user_url) unless @user
    end
end
