class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_branch, only: [:create, :new]
  before_action :set_cart, only: [:create, :new]
  before_action :check_sufficient_stock, only: [:create]

  def create
    if @order.save
      redirect_with_flash("success", "successfully_placed", new_charge_path)
    else
      render 'new'
    end
  end

  def check_sufficient_stock
    @order = Order.new(permitted_params)
    unless @order.sufficient_stock
      session[:cart_id] = nil
      redirect_with_flash("danger", "insufficient_stock", store_index_path)
    end
  end


  def new
    if current_user
      @order = Order.new
    else
      redirect_with_flash("danger", "login", login_path)
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    if @order.pick_up - Time.current > 30
      @order.destroy
      @order.affect_ingredient("+")
      redirect_with_flash("success", "order_cancelled", myorders_url)
    else
      redirect_with_flash("danger", "time_up", myorders_url)
    end
  end

  private
    def permitted_params
      params.require(:order).permit(:pick_up, :phone_number, :user_id, :branch_id, :cart_id)
    end
end
