FactoryBot.define do
  factory :inventory do
    quantity { 2 }
    association :branch, factory: :branch
    association :ingredient, factory: [:ingredient, :veg]
  end
end
