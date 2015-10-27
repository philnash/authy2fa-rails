Rails.application.routes.draw do
  # Account section
  resource :account, only: [:show]

  # Sessions
  resources :sessions, only: [:new, :create]
  get "sessions/destroy"
  get "sessions/two_factor"

  post "authy/callback" => 'authy#callback'
  get "authy/status" => 'authy#one_touch_status'
  post "authy/send_token"
  post "authy/verify"

  # Create users
  resources :users, only: [:new, :create]

  # Home page
  root 'main#index'
end
