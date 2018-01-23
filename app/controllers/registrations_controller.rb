class RegistrationsController < ApplicationController

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

  private
    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end
end
