class Admin::OrdersController < Admin::BaseController
  before_action :set_orders, only: [:index, :update_orders]
  before_action :set_order, only: [:toggle_pick_up_status, :toggle_ready_status, :destroy]

  def toggle_pick_up_status
   unless @order.ready
      redirect_with_flash("danger", "order_not_prepared", admin_orders_path)
    else
      @order.delivered
      redirect_with_flash("success", "status_changed", admin_orders_path)
    end
  end

  def toggle_ready_status
    @order.prepared
    redirect_with_flash("success", "status_changed", admin_orders_path)
  end

  def update_orders
    output = render_to_string partial: "order"
    render json: { output: output }
  end

  def destroy
    if @order.destroy
      redirect_with_flash("success", "order_cancelled", admin_orders_path)
    else
      redirect_with_flash("danger", "error", admin_orders_path)
    end
  end

  private
    def set_order
      @order = Order.find_by(id: params[:id])
      unless @order
        redirect_with_flash("danger", "not_found", admin_orders_path)
      end
    end

    def set_orders
      @orders = @branch.orders.includes(:charge).all
    end
end
