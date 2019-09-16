FactoryBot.define do
  factory :conversation_user do
    association :conversation
    association :user
  end
end
