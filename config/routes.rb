RailstutChap3::Application.routes.draw do
  get "users/new"

  match '/signup', :to => 'users#new'

  root :to => 'pages#home'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
end
