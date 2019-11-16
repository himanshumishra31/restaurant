FactoryBot.define do
  factory :line_item do
    quantity { 1 }
    association :meal, factory: [:meal, :active_meal]
  end
end
