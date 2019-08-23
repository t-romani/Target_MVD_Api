FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password }
    full_name { Faker::Name.name_with_middle }
    gender    { User.genders.keys.sample }
    after :create, &:confirm
  end
end
