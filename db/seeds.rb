titles = ['The Pragmatic Programmer', 'The Stupendous Origin', 'The Awakening of the Sencha']
titles.each do |title|
  Topic.find_or_create_by(title: title)
end

AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
User.create(email: 'tiziana.romani@rootstrap.com', password: 'aaaaaa', password_confirmation: 'aaaaaa', gender: 'female', full_name:'Tiziana')
User.create(email: 'tiziana.romani1@rootstrap.com', password: 'aaaaaa', password_confirmation: 'aaaaaa', gender: 'female', full_name: 'Tiziana')
User.create(email: 'tiziana.romani2@rootstrap.com', password: 'aaaaaa', password_confirmation: 'aaaaaa', gender: 'female', full_name: 'Tiziana')

Target.create(topic_id:2, user_id:1, title:"I like Tea", radius:200, latitude:-34.55543, longitude:-56.323456)
Target.create(topic_id:2, user_id:2, title:"I like Trains", radius:200, latitude:-34.55543, longitude:-56.323456)
Target.create(topic_id:2, user_id:3, title:"I like Turtles", radius:200, latitude:-34.55543, longitude:-56.323456)
