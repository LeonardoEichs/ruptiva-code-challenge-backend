Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # resources :users
  get '/users/', to: 'users#index'
  get '/users/:id', to: 'users#show'
  devise_scope :user do
    post '/users', to: 'devise_token_auth/registrations#create'
  end
  put '/users/:id', to: 'users#update'
  patch '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'


end
