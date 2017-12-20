class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :set_correct_user, only: [:show, :edit, :update]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        UserMailer.registration_confirmation(@user).deliver
        flash[:success] = 'Please confirm your email'
        format.html { redirect_to 'www.google.com', notice: "User #{ @user.name } was successfully created " }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessabe_entity }
      end
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to the Sample App! Your email has been confirmed. Please sign in to continue."
      redirect_to login_url
    else
      flash[:error] = 'Sorry. User does not exist. Please sign up'
      redirect_to new_user_url
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Changes have been successfully saved"
      redirect_to login_url
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def set_correct_user
      @user = User.find(params[:id])
      redirect_to login_url unless @user == current_user
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = 'Please Log in'
        redirect_to login_url
      end
    end

end
