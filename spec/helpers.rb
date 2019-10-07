def auth_user_headers
  user.create_new_auth_token
end

def another_auth_user_headers
  another_user.create_new_auth_token
end

def parsed_data
  JSON.parse(response.body)
end

def conversation_user
  ConversationUser.where(conversation_id: conversation.id)
                  .where(user_id: user.id).first
end
