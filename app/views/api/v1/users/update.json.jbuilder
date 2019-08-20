json.data do
  json.user do
    json.name @current_user.full_name
    json.gender @current_user.gender
  end
end
