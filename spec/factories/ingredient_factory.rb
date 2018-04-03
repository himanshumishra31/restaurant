FactoryBot.define do
  factory :ingredient do
    name { Faker::Name.unique.name }
    price { Faker::Number.number(2) }

    trait :veg do
      category Ingredient::VALID_CATEGORIES[:veg]
    end

    trait :non_veg do
      category Ingredient::VALID_CATEGORIES[:non_veg]
    end
  end
end
