# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



user1 = User.find_or_create_by(email: 'test1@marketingguru.com') do |u|  
  u.name = 'Thomas Muller'  
  u.password = 'password'
end
user2 = User.find_or_create_by(email: 'test2@marketingguru.com') do |u|  
  u.name = 'Cristiano Ronaldo'  
  u.password = 'password'
end
user3 = User.find_or_create_by(email: 'test3@marketingguru.com') do |u|  
  u.name = 'Lionel Messi'
  u.password = 'password'  
end
user4 = User.find_or_create_by(email: 'test4@marketingguru.com') do |u|  
  u.name = 'Arjen Robben'
  u.password = 'password'  
end
user5 = User.find_or_create_by(email: 'test5@marketingguru.com') do |u|  
  u.name = 'David Luiz'
  u.password = 'password'
end