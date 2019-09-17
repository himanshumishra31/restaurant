class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_user, only: [:confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      redirect_with_flash("success", "confirm_email", store_index_url)
    else
      render :new
    end
  end

  def confirm_email
    @user.activate_email
    redirect_with_flash("success", "email_confirmed", login_url)
  end

  private
    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def load_user
      @user = User.find_by(confirmation_token: params[:id])
      redirect_with_flash("danger", 'already_confirmed', login_url) unless @user
    end
end
