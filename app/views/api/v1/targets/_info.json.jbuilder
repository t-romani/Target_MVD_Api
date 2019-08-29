json.id           target.id
json.topic_id     target.topic_id
json.title        target.title
json.radius       target.radius
json.latitude     target.latitude
json.longitude    target.longitude
json.created_at   target.created_at
json.updated_at   target.updated_at
json.user do
  json.id         user.id
  json.full_name  user.full_name
  json.email      user.email
end
