# By using the :user symbol we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                   "Test User"
  user.email                  "test@example.com"
  user.password               "secret"
  user.password_confirmation  "secret"
end

Factory.sequence :email do |n|
  "test-user-#{n}@example.com"
end
