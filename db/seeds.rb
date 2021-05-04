# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all

User.create(
  first_name: "marie",
  last_name: "angot",
  phone_number: "061234675678",
  email: "marie@yopmail.com",
  encrypted_password: "000000",
)

puts "marie create"

User.create(
  first_name: "jacqueline",
  phone_number: "0622334455",
  email: "jacqueline@yopmail.com",
  encrypted_password: "000000",
)

puts "jacqueline create"

User.create(
  first_name: "laurence",
  phone_number: "0766778899",
  email: "laurence@yopmail.com",
  encrypted_password: "000000",
)

puts "laurence create"

article_title = ["fauteil louis XV", "Chaise vintage", "chaine de table", "tabouret", 
  "chaise", "banquette", "banquette ancienne", "banquette ancienne", "chaise d'époque", 
  "fauteuil club", "tabouret vintage" ]

12.times do
  Article.create(
    title: article_title.sample,
    user_id: 1
  )
end

puts "12 article"