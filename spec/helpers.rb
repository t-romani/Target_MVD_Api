def auth_user_headers
  user.create_new_auth_token
end

def parsed_data
<<<<<<< HEAD
  JSON.parse(response.body)
end
=======
  data = JSON.parse(response.body)
end
>>>>>>> cf90f2f... PR5 fixes
