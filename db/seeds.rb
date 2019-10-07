titles = ['The Pragmatic Programmer', 'The Stupendous Origin', 'The Awakening of the Sencha']
titles.each do |title|
  Topic.find_or_create_by(title: title)
end

User.create!(email:"tiziana.romani@rootstrap.com", gender: 'female', full_name: 'Tiziana', password: 'aaaaaa', password_confirmation: 'aaaaaa') if User.where(email: 'tiziana.romani@rootstrap.com').blank?
User.create!(email:"tiziana.romani1@rootstrap.com", gender: 'female', full_name: 'Tiziana', password: 'aaaaaa', password_confirmation: 'aaaaaa') if User.where(email: 'tiziana.romani1@rootstrap.com').blank?
User.create!(email:"tiziana.romani2@rootstrap.com", gender: 'female', full_name: 'Tiziana', password: 'aaaaaa', password_confirmation: 'aaaaaa') if User.where(email: 'tiziana.romani2@rootstrap.com').blank?


User.first.targets.find_or_create_by(
  topic_id: 1,
  title: 'Fields',
  radius: 500,
  latitude: -34.9071161,
  longitude: -56.2033275
)

User.second.targets.find_or_create_by(
  topic_id: 1,
  title: 'Oceans',
  radius: 250,
  latitude: -34.9071165,
  longitude: -56.2033275
)

User.third.targets.find_or_create_by(
  topic_id: 1,
  title: 'Mountains',
  radius: 400,
  latitude: -34.9071167,
  longitude: -56.2033270
)

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && AdminUser.where(email: 'admin@example.com').blank?
