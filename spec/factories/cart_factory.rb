FactoryBot.define do
  factory :cart do
    after(:build) do |cart|
      cart.line_items = create_list(:line_item, 1, cart: cart)
    end
  end
end
