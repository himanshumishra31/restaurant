FactoryBot.define do
  factory :ingredient do
    name { Faker::Name.unique.name }
    price { Faker::Number.number(2) }

    trait :veg do
      category 'veg'
    end

    trait :non_veg do
      category 'non_veg'
    end
  end
end
