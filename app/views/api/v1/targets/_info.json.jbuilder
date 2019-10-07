json.id              target.id
json.topic_id        target.topic_id
json.title           target.title
json.radius          target.radius
json.latitude        target.latitude
json.longitude       target.longitude

json.user user, partial: 'api/v1/users/info', as: :user
