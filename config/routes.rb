# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users, param: :slug
  end

  resources :default_bills, param: :slug
  resources :accounts, param: :slug
  resources :categories, param: :slug

  post '/auth/login', to: 'authentication#login'
  post '/register', to: 'users#create'
end
