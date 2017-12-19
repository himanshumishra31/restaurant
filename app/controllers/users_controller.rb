class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
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

  private
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end
end
