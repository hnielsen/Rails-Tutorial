RailstutChap3::Application.routes.draw do
  resources :users

  match '/signup', :to => 'users#new'

  root :to => 'pages#home'
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
end
