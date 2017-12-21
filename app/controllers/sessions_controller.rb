class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.email_confirmed
        log_in(user)
        params[:remember_me] == 'on' ? remember(user) : forget(user)
        redirect_to new_user_path
      else
        flash[:danger] = 'Please activate your account by following instructions in the confirmation email that you received'
        redirect_to new_user_url
      end
    else
      flash[:danger] = "Invalid user/password combination"
      redirect_to login_url
    end
  end

  def destroy
    logout if logged_in?
    redirect_to login_url
  end
end
