FactoryBot.define do
  factory :order do
    phone_number { Faker::Base.numerify('9#########') }
    pick_up { 1.hour.from_now }
    association :branch, factory: :branch
    association :user, factory: [ :user, :user_confirmed, :customer ]
    association :cart, factory: :cart
  end
end
