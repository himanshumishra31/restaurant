class Admin::OrdersController < Admin::BaseController
  before_action :set_branch
  before_action :set_orders, only: [:index, :update_orders]
  before_action :set_order, only: [:toggle_pick_up_status, :toggle_ready_status]

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

  # FIX_ME_PG:- Make methods private.
  # FIX_ME_PG:- What if @order is nil? Check all over the code.
  def set_order
    @order = Order.find_by(id: params[:id])
  end

  def update_orders
    output = render_to_string partial: "order"
    render json: { output: output }
  end

  def set_orders
    @orders = @branch.orders.includes(:charge).all
  end
end
