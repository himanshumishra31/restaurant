class ChargesController < ApplicationController
  before_action :set_order

  def new
    redirect_with_flash("danger", "invalid_cart", store_index_path) unless @order
  end

  def create
    charge = @order.build_charge.create_new_charge(params[:stripeToken])
    if charge.errors.blank?
      session[:cart_id] = nil
      @order.affect_ingredient("-")
      redirect_with_flash("success", "payment_success", store_index_path)
    else
      flash[:danger] = charge.errors.messages.values.split.join(', ')
      render :new
    end
  end

  private
    def set_order
      @order = Order.find_by(cart_id: session[:cart_id])
      redirect_with_flash("danger", "flash", store_index_path) unless @order
    end
end
