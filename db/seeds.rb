# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "------------admin create----------------"
Admin.destroy_all
Admin.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
  )
puts "------------customer create----------------"
Customer.destroy_all
10.times do
  name = Faker::Name.name
  truncated_name = name[0, 10]
  Customer.create!(
    name: truncated_name,
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
