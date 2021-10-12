# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Category.destroy_all
Column.destroy_all


admin = User.create(
  first_name: "francine",
  last_name: "amsellen",
  email: "francine@yopmail.com",
  password: "chevry",
  is_admin: true,
)

puts "admin user create"

user = User.create(
  first_name: "marie",
  last_name: "angot",
  email: "marie@yopmail.com",
  password: "chevry",
  is_admin: false,
)

puts "user create"

article_category = ["fauteuil", "chaise", "canapé", "pouf"]

for i in 0...article_category.length do
  Category.create(
    name: article_category[i],
    display: false
  )
end

puts "#{article_category.length} category créées"


post_column = ["annonce club", "achat", "recherche", "bon plan", "divers"]
  
  for i in 0...post_column.length do
    Column.create(
      name: post_column[i],
    )
  end
