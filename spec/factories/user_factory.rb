FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }

    trait :user_confirmed do
      confirmed true
      confirmation_token nil
    end

    trait :user_not_confirmed do
      confirmed false
      confirmation_token { Faker::Lorem.word }
    end

    trait :customer do
      role 'customer'
    end

    trait :admin do
      role 'admin'
    end
  end
end
