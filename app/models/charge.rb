class Charge < ApplicationRecord

  belongs_to :order

  validates :customer_id, :status, :amount, :last4, presence: true

  def create_new_charge(token)
    customer = create_stripe_customer(token)
    charge = create_stripe_charge(customer.id)
    return self if errors.any?
    add_fields_to_charge(charge)
    self
  end

  def create_stripe_customer(token)
    begin
      Stripe::Customer.create(
        email: order.user.email,
        source: token
      )
    rescue Stripe::StripeError => e
      errors[:customer] << e.message
    end
  end

  def create_stripe_charge(customer_id)
    begin
      Stripe::Charge.create(
        customer: customer_id,
        amount: (order.cart.total_price).to_i,
        description: 'Restaurant Order',
        currency: 'usd',
        metadata: {
          order_number: order.id
        }
      )

    rescue Stripe::CardError => e
      errors[:card] << e.message
    rescue Stripe::StripeError => e
      errors[:base] << e.message
    end
  end

  def add_fields_to_charge(charge)
    self.customer_id =  charge.customer
    self.amount = charge.amount
    self.status = charge.status
    self.last4 = charge.source.last4
    save!
  end
end
