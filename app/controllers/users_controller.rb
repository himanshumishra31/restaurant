class UsersController < ApplicationController
  before_action :authorize, only: [:edit, :update]
  before_action :can_edit_self_only, only: [:show, :edit, :update]
  before_action :get_user_from_email_verification, only: [:confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params)
    if @user.save
      flash_message("success", "confirm_email")
      redirect_to login_url
    else
      render 'new'
    end
  end

  def confirm_email
    @user.activate_email
    flash_message("success", "email_confirmed")
    redirect_to login_url
  end

  def update
    if @user.update(permitted_params)
      flash_message("success", "successfully_saved")
      redirect_to login_url
    else
      render 'edit'
    end
  end

  private
    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def can_edit_self_only
      @user = User.find(session[:user_id])
      unless @user == current_user
        flash_message("danger", "other_account")
        redirect_to login_url
      end
    end

    def get_user_from_email_verification
      @user = User.find_by(id: params[:id])
      unless @user
        flash_message("danger", 'user_not_exist')
        redirect_to new_user_url
      end
    end

end
