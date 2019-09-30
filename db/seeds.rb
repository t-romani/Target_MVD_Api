# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
titles = ['The Pragmatic Programmer', 'The Stupendous Origin', 'The Awakening of the Sencha']
titles.each do |title|
  Topic.find_or_create_by(title: title)
end

# user = User.new
# user.email = 'tiziana.romani@rootstrap.com'
# user.password = 'aaaaaa'
# user.password_confirmation = 'aaaaaa'
# user.gender = 'female'
# user.full_name = 'Sassss'
# user.confirm
# user.save

# user = User.new
# user.email = 'tiziana.romani1@rootstrap.com'
# user.password = 'aaaaaa'
# user.password_confirmation = 'aaaaaa'
# user.gender = 'female'
# user.full_name = 'Sassss'
# user.confirm
# user.save

# user = User.new
# user.email = 'tiziana.romani2@rootstrap.com'
# user.password = 'aaaaaa'
# user.password_confirmation = 'aaaaaa'
# user.gender = 'female'
# user.full_name = 'Sassss'
# user.confirm
# user.save

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
