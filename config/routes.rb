Rails.application.routes.draw do
  resources :likes
  resources :comments
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'password_reset/new'

  get 'password_reset/edit'

  get 'password_reset/update'

  get 'password_reset/create'

  get 'account_activations/create'

  get 'account_activations/edit'

  get '/login', to: 'session#new'

  post '/login', to: 'session#create'

  delete '/logout', to: 'session#destroy'

  root 'static_pages#home'
  get '/home', to: 'static_pages#home'

  get '/help', to: 'static_pages#help'

  get '/about', to: 'static_pages#about'

  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  resources :microposts
  resources :users
  resources :account_activations, only: [:edit, :update, :create]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
