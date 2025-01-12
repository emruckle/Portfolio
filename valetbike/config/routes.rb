Rails.application.routes.draw do
  root to: "home#index"
  get '/bikes', to: 'bikes#index'
  get '/stations', to: 'stations#index'
  get '/stations/:id', to: 'stations#show', as: 'station'
  get '/return', to: 'bikes#index'
  get '/users', to: 'users#index'
  resources :rentals
  resources :users do
    get 'history', on: :member
  end
  get '/about', to: 'about#index'
  get '/signup', to: 'users#new', as: 'signup'
  resources :users, only: [:create, :update, :edit, :show, :destroy]
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :bikes do
    member do
      patch 'return'  # PATCH request to handle the return action for a specific bike
    end
  end
  post 'create-checkout-session', to: 'stripe#create_checkout_session'
  get '/stripe/success', to: 'stripe#success', as: 'stripe_success'
end
