# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
password = '12345678'

User.create(
  name: Faker::Name.name,
  email: "ernestohlacalle@gmail.com",
  password: password,
  password_confirmation: password,
  admin: true,
  activated_at: Time.zone.now
)

99.times do |n|
  User.create(
    name: Faker::Name.name,
    email: "email#{n}@example.com",
    password: password,
    password_confirmation: password,
    activated: false,
    activated_at: Time.zone.now
  )
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
