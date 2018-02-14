class ChargesController < ApplicationController
  before_action :set_order

  def new
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
      @order = Order.find_by(id: params[:id])
      unless @order
        redirect_with_flash("danger", "not_found", store_index_path)
      end
    end
end
