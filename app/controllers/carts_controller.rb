class CartsController < ApplicationController
  before_action :set_cart, only: [:update, :destroy]

  def destroy
    @cart.destroy if @cart.id = session[:cart_id]
    session[:cart_id] = nil
    redirect_to store_index_url
  end

  private
    def set_cart
      @cart = Cart.find_by(id: params[:id])
    end

end
