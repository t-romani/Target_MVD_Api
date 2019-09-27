json.id        user.id
json.name      user.full_name
json.email     user.email
json.avatar    polymorphic_url(user.avatar)
