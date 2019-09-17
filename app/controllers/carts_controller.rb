class CartsController < ApplicationController
  before_action :load_cart, only: [:update, :destroy]

  def destroy
    @cart.destroy if @cart.id = session[:cart_id]
    session[:cart_id] = nil
    redirect_to store_index_url
  end

  private
    def load_cart
      @cart = Cart.find_by(id: params[:id])
      redirect_with_flash("danger", "not_found", store_index_url) unless @cart
    end
end
