FactoryBot.define do
  factory :meal do
    name { Faker::Friends.character }
    trait :active_meal do
      active true
    end

    trait :inactive_meal do
      active false
    end

    after(:build) do |meal|
      meal.meal_items = create_list(:meal_item, 1, meal: meal)
    end
  end
end
