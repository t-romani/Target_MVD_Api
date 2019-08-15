FactoryBot.define do
  factory :user do
    email { 'test_user@example.com' }
    password { 'example' }
    password_confirmation { 'example' }
    full_name { 'Testereck Usernder' }
    gender { 2 }
  end

  factory :confirmed_user, parent: :user do
    after :create, &:confirm
  end
end
