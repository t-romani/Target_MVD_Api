FactoryBot.define do
  factory :conversation_user do
    conversation
    user
    unread_messages { 0 }
  end
end
