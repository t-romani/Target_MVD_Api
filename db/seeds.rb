# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
t = Topic.create(
  'id': 7,
  'title': 'The Pragmatic Programmer',
  'created_at': '2019-08-26T15:27:50.113Z',
  'updated_at': '2019-08-26T15:27:50.113Z'
)
t.image.attach(io: File.open("#{Rails.root}/public/images/rootstrap.png"), filename: "rootstrap.png")

t = Topic.create(
  'id': 8,
  'title': 'The Stupendous Origin',
  'created_at': '2019-08-26T15:27:50.113Z',
  'updated_at': '2019-08-26T15:27:50.113Z'
)
t.image.attach(io: File.open("#{Rails.root}/public/images/rootstrap.png"), filename: "rootstrap.png")

t= Topic.create(
  'id': 9,
  'title': 'The Awakening of the Sencha',
  'created_at': '2019-08-26T15:27:50.113Z',
  'updated_at': '2019-08-26T15:27:50.113Z'
)
t.image.attach(io: File.open("#{Rails.root}/public/images/rootstrap.png"), filename: "rootstrap.png")
