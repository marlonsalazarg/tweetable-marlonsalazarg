puts "Destroying all users..."
User.destroy_all
puts "Destroying all tweets..."
Tweet.destroy_all
puts "Destroying all likes..."
Like.destroy_all

puts "Creating users..."
User.find_or_create_by(username: "admin_test") do |user|
  user.email = "admin@mail.com"
  user.name = "Admin"
  user.password = "123456"
  user.role = "admin"
end

User.find_or_create_by(username: "dogfire") do |user|
  user.email = "dog@mail.com"
  user.name = "House on Fire"
  user.password = "123456"
  user.avatar.attach(io: File.open("db/images/dog_profile.png"), filename: "dog_profile.png")
end

User.find_or_create_by(username: "drRealNeil") do |user|
  user.email = "neil@mail.com"
  user.name = "The Real Neil"
  user.password = "123456"
  user.avatar.attach(io: File.open("db/images/person_profile.png"), filename: "person_profile.png")
end

User.find_or_create_by(username: "thefist") do |user|
  user.email = "fist@mail.com"
  user.name = "The Fist"
  user.password = "123456"
  user.avatar.attach(io: File.open("db/images/rectangle_profile.png"), filename: "rectangle_profile.png")
end

User.find_or_create_by(username: "tanus") do |user|
  user.email = "tanus@mail.com"
  user.name = "The Great Tanus"
  user.password = "123456"
  user.avatar.attach(io: File.open("db/images/thanos_profile.png"), filename: "thanos_profile.png")
end
# Each member should create some tweets
puts "Creating tweets..."
User.all.each do |user|
  2.times do
    user.tweets.create(body: Faker::Lorem.sentence(word_count: 10))
  end
end
# Each member should reply to some other tweets
puts "Creating replies..."
Tweet.all.each do |tweet|
  2.times do
    tweet.replies.create(body: Faker::Lorem.sentence(word_count: 10), user_id: User.all.sample.id)
  end
end

#Each member should like some tweets
puts "Creating likes..."
User.all.each do |user|
  rand(1..4).times do
    user.likes.create(tweet_id: Tweet.all.sample.id)
  end
end
