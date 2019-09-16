json.conversation do
  json.id conversation.id
  json.users conversation.not_current_user(@user),
             partial: 'api/v1/users/info',
             as: :user

  json.messages @conversation.messages do |message|
    json.message message, partial: 'api/v1/messages/info',
                          as: :message
  end
end
