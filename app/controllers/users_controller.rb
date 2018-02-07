class UsersController < ApplicationController
  # FIX_ME:- This before action should be called on every action. Skip it where not needed. Rename to `def authenticate_user!`
  before_action :authorize, only: [:edit, :update]
  before_action :validate_user, only: [:edit, :update]
  before_action :load_user, only: [:confirm_email]

  # FIX_ME:- lets move this to registration controller.
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
    # FIX_ME:- Use @current_user here. Try to use the instance variables where needed instead of calling method.
    # FIX_ME:- Includes can be written as `includes(:charge, :branch, :cart)`.
    # FIX_ME:- Lets make a good UI, filter order on basis of picked/cancelled/ next pickup, etc.
    @orders = current_user.orders.includes(:charge).includes(:branch).includes(:cart)
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    # FIX_ME:- User should only edit his/her details which will always be @current_user. No need for before action. 
    def validate_user
      @user = User.find_by(session[:user_id])
      redirect_with_flash("danger", "other_account", login_url) unless @user == @current_user
    end

    def load_user
      @user = User.find_by(confirmation_token: params[:id])
      redirect_with_flash("danger", 'already_confirmed', login_url) unless @user
    end

end
