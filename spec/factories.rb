###############################################
# User
###############################################

# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Test User"
  user.email                 "test.user@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

###############################################
# Micropost
###############################################

Factory.define :micropost do |micropost|
  micropost.content "This is a micro-post."
  micropost.association :user
end