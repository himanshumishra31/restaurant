class OrdersController < ApplicationController
  before_action :set_cart, only: [:create, :new]
  before_action :check_sufficient_stock, only: [:create]
  before_action :set_order_by_feedback_digest, only: [:feedback]
  before_action :link_expired?, only: [:feedback]
  before_action :is_user_logged_in?, only: [:feedback]
  before_action :set_order, only: [:destroy]
  skip_before_action :authenticate_user!, only: [:feedback]
  def create
    if @order.save
      session[:cart_id] = nil
      redirect_with_flash("success", "successfully_placed", new_charge_path(@order))
    else
      render :new
    end
  end


  def new
    @order = @current_user.orders.build
  end

  def destroy
    if @order.cancellable?
      @order.destroy
      @order.affect_ingredient("+")
      redirect_with_flash("success", "order_cancelled", myorders_users_url)
    else
      redirect_with_flash("danger", "time_up", myorders_users_url)
    end
  end

  private

    def set_order
      @order = Order.find_by(id: params[:id])
      unless @order
        redirect_with_flash("danger", "not_found", store_index_path)
      end
    end

    def check_sufficient_stock
      @order = @current_user.orders.build(permitted_params)
      unless @order.sufficient_stock
        session[:cart_id] = nil
        redirect_with_flash("danger", "insufficient_stock", store_index_path)
      end
    end

    def set_order_by_feedback_digest
      @order = Order.find_by(feedback_digest: params[:id])
      unless @order
        redirect_with_flash("danger", "not_found", store_index_path)
      end
    end

    def link_expired?
      if @order.feedback_link_expired?
        redirect_with_flash("danger", "link_expired", store_index_path)
      end
    end

    def is_user_logged_in?
      unless @order.user.id.eql? session[:user_id]
        session[:feedback_url] = request.url
        redirect_with_flash("danger", "login", login_path)
      end
    end

    def permitted_params
      params.require(:order).permit(:pick_up, :phone_number, :branch_id, :cart_id)
    end
end
