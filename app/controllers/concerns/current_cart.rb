#FIX_ME:- I dont think we need this. Insteaad move to application controller.
module CurrentCart
  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])
    unless @cart
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end
end
