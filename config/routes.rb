Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  resources :pages, only: [:show]
  resources :shopping_cart_items, only: %i[index create update destroy]

  resources :orders, only: %i[new create show]
  resource :user, only: %i[show edit update]

  # Define the root path route ("/")
  root 'products#index'

  # Define static pages routes
  get 'contact', to: 'pages#show', defaults: { id: 'contact' }
  get 'about', to: 'pages#show', defaults: { id: 'about' }
end
