json.conversation do
  json.id conversation.id
  json.users conversation.not_current_user(@user),
             partial: 'api/v1/users/info',
             as: :user

  json.partial! 'api/v1/messages/index', messages: conversation.messages
end
