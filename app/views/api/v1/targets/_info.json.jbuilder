json.extract! target, :id, :topic_id, :title, :radius, :latitude, :longitude
json.user user, partial: 'api/v1/users/info', as: :user
