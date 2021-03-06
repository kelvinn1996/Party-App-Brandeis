# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(username:  "Kelvin",
             email: "kelvin@brandeis.edu",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             radius: 5)

User.create!(username:  "Erica",
             email: "cher13@brandeis.edu",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             radius: 5)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@brandeis.edu"
  password = "password"
  radius = 5
  User.create!(username:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               radius: 5)
end
