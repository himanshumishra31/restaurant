FactoryBot.define do
  factory :meal_item do
    quantity { 1 }
    association :ingredient, factory: [:ingredient, :veg]
  end
end
