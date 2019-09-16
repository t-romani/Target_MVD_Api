FactoryBot.define do
  factory :message do
    text { Faker::Lorem.sentence(word_count: 3) }
    user
    conversation
  end
end
