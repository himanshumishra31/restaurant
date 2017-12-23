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
      flash[:success] = 'Please confirm your email'
      redirect_to login_url
    else
      render 'new'
    end
  end

  def confirm_email
    @user.activate_email
    flash[:success] = "Your email has been confirmed. Please sign in to continue."
    redirect_to login_url
  end

  def update
    if @user.update(permitted_params)
      flash[:success] = "Changes have been successfully saved"
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
        flash[:danger] = "Can't edit other's account"
        redirect_to login_url
      end
    end

    def get_user_from_email_verification
      @user = User.find_by(id: params[:id])
      unless @user
        flash[:danger] = 'Sorry. User does not exist. Please sign up'
        redirect_to new_user_url
      end
    end

end
