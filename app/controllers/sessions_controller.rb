class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.email_confirmed
        session[:user_id] = user.id
        redirect_to new_user_path
      else
        flash[:notice] = 'Please activate your account by following instructions in the confirmation email that you received'
        puts 'Please activate your account by following instructions in the confirmation email that you received'
        redirect_to new_user_url
      end
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end
end
