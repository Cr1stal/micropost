
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationship
  end
end

def make_users
  admin = User.create!(name: "Example User", email: "example@example.net",
                       password: "barfoo", password_confirmation: "barfoo", admin: true)

    User.create!(name: "Example User", email: "example@example.com",
    password: "foobar", password_confirmation: "foobar")
    30.times do |n|
      random_names = ["mail", "gmail", "hotmail", "yahoo", "bing"]
      example = random_names.sample
      fullName = Faker::Name.name
      name = fullName.gsub(/\s+/, '')
      email = "#{name}@#{example}.com"
      password = "password"
      User.create!(name: fullName, email: email,
                   password: password, password_confirmation: password)
    end
    # users = User.all(limit:6) is wrong !!!

  end


def make_microposts
  users = User.all.limit(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
end

def make_relationship
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..35]
  followed_users.each {|followed| user.follow!(followed)}
  followers.each      {|follower| follower.follow!(user)}
end
