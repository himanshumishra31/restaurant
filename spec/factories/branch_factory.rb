FactoryBot.define do
  factory :branch do
    name { Faker::Name.unique.name }
    opening_time { 4.hour.ago }
    closing_time { 4.hour.from_now }
    contact_number { Faker::Base.numerify('9#########') }
    address { Faker::Address.city }

    trait :default do
      default true
    end

    trait :not_default do
      default false
    end

    after(:create) do |branch|
      branch.orders = create_list(:order, 1, branch: branch)
    end

  end
end
