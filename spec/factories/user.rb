include ActionDispatch::TestProcess

FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password }
    full_name { Faker::Name.name_with_middle }
    gender    { User.genders.keys.sample }
    player_id { Faker::Alphanumeric.alphanumeric(number: 32) }
    after :create, &:confirm

    trait :with_avatar do
      avatar do
        fixture_file_upload(
          Rails.root.join('spec', 'support', 'images', 'rootstrap.png'), 'image/png'
        )
      end
    end
  end
end
