FactoryBot.define do
  factory :branch do
    name { Faker::Name.unique.name }
    opening_time { 4.hour.ago }
    closing_time { 4.hour.from_now }
    contact_number { '9654208158' }
    address { '3/11 east patel nagar'}

    trait :default do
      default true
    end

    trait :not_default do
      default false
    end

    after(:create) do |branch|
      branch.inventories = create_list(:inventory, 1, branch: branch)
      branch.orders = create_list(:order, 1, branch: branch)
    end

  end
end
