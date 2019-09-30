FactoryBot.define do
  factory :contact do
    text  { Faker::Lorem.sentence(word_count: 20) }
    user
  end
end
