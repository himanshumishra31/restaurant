class CartsController < ApplicationController
  before_action :set_cart, only: [:update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart


  def destroy
    @cart.destroy if @cart.id = session[:cart_id]
    session[:cart_id] = nil
    redirect_to store_index_url
  end

  private

    def set_cart
      @cart = Cart.find(params[:id])
    end

    def invalid_cart
      logger.error "Attempt to access invalid cart #{ params[:id]}"
      redirect_with_flash("danger", "invalid_cart", store_index_url)
    end
end
