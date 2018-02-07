class UsersController < ApplicationController
  before_action :authorize, only: [:edit, :update]
  before_action :validate_user, only: [:edit, :update]
  before_action :load_user, only: [:confirm_email]

  def confirm_email
    @user.activate_email
    redirect_with_flash("success", "email_confirmed", login_url)
  end

  def update
    if @user.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", store_index_url)
    else
      render :edit
    end
  end

  def myorders
    @orders = current_user.orders.includes(:charge).includes(:branch).includes(:cart)
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def validate_user
      @user = User.find_by(session[:user_id])
      redirect_with_flash("danger", "other_account", login_url) unless @user == @current_user
    end

    def load_user
      @user = User.find_by(confirmation_token: params[:id])
      redirect_with_flash("danger", 'already_confirmed', login_url) unless @user
    end
end
