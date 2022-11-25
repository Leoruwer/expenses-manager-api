Rails.application.routes.draw do
  namespace :admin do
    resources :users, param: :slug
  end

  post '/auth/login', to: 'authentication#login'
  post '/register', to: 'users#create'
end
