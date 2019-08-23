FactoryBot.define do
  factory :user do
    email     { 'test_user@example.com' }
    password  { Faker::Internet.password }
    full_name { Faker::Name.name_with_middle }
    gender    { 2 }

    trait :confirmed do
      after :create, &:confirm
    end
  end
end
