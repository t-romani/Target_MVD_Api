def auth_user_headers
  user.create_new_auth_token
end

def parsed_data
  JSON.parse(response.body)
end
