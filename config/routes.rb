Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :shopping_cart_items, only: %i[index create update destroy]
  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :pages, only: [:show]

  # Ensure all RESTful routes for orders are defined
  resources :orders, only: %i[index new create show] do
    member do
      patch 'update_status', to: 'orders#update_status'
    end
  end

  resource :user, only: %i[show edit update]

  # Define the root path route ("/")
  root 'products#index'

  # Define static pages routes
  get 'contact', to: 'pages#show', defaults: { id: 'contact-us' }
  get 'about', to: 'pages#show', defaults: { id: 'about-us' }

  # Define shipping types route
  resources :shipping_types, only: [] do
    member do
      get 'price'
    end
  end
end
