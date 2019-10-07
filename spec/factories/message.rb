FactoryBot.define do
  factory :message do
    text          { Faker::Lorem.sentence(word_count: 3) }
    message_type  { Message.message_types[:user] }
    user
    conversation

    trait :match do
      message_type { Message.message_types[:match] }
      text         { 'You have a new match!' }
    end
  end
end
