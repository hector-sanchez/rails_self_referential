# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Get access to factory girl and it's syntax methods

require "factory_bot"
require "./test/factories/users_factories.rb"

include FactoryBot::Syntax::Methods

puts "Destroying previous users..."
User.destroy_all

puts "Creating list of users..."
FactoryBot.create_list(:user, 20)

# create the follow/follower
User.all.each do |user|
  users_to_follow = User.where.not(id: user.id).sample(10)

  puts "Building Follower/Followee relationship..."
  users_to_follow.each do |utf|
    Follow.create(follower_id: user.id, followee_id: utf.id)
    puts "#{user.username} is now following #{utf.username}"
  end

  puts "Sending/receiving messages..."
  users_to_follow.each do |utf|
    msg = Faker::TvShows::DumbAndDumber.quote
    Message.create(sender_id: user.id, receiver_id: utf.id, message: msg)
    puts "#{user.username} is sending the message '#{msg}' #{utf.username}"
  end
end
