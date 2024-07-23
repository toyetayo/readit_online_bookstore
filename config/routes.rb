Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :pages, only: [:show]
  resources :shopping_cart_items, only: %i[index create update destroy]
  resources :orders, only: %i[new create show]
  resource :user, only: %i[show edit update]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Define the root path route ("/")
  root 'products#index'

  # Define static pages routes
  get 'contact', to: 'pages#show', defaults: { id: 'contact' }
  get 'about', to: 'pages#show', defaults: { id: 'about' }
end
