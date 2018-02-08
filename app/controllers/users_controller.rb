class UsersController < ApplicationController

  def update
    if @current_user.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", store_index_url)
    else
      render :edit
    end
  end

  def myorders
    @orders = @current_user.orders.includes(:charge, :branch, :cart)
  end

  private

    def permitted_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
