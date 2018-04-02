FactoryBot.define do
  factory :order do
    phone_number { '9654208158' }
    charge { Charge.first }
    pick_up { Branch.first.opening_time + 6.hour }
    association :branch, factory: :branch
    association :user, factory: [ :user, :user_confirmed, :customer ]
    association :cart, factory: :cart
  end
end
