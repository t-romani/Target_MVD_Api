json.extract! conversation, :id
json.users conversation.not_current_user(user),
           partial: 'api/v1/users/info',
           as: :user
json.unread_messages conversation.unread_count
