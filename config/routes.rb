Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :shopping_cart_items, only: %i[index create update destroy]
  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :pages, only: [:show]

  resources :orders, only: %i[new create show]
  resource :user, only: %i[show edit update]

  # Define the root path route ("/")
  root 'products#index'

  get 'fetch_categories', to: 'categories#fetch'

  # Define static pages routes
  get 'contact', to: 'pages#show', defaults: { id: 'contact-us' }
  get 'about', to: 'pages#show', defaults: { id: 'about-us' }
end
