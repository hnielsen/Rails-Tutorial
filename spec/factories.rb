# By using the :user symbol we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                   "Henrik Nielsen"
  user.email                  "hni@example.com"
  user.password               "secret"
  user.password_confirmation  "secret"
end
