Rails.application.routes.draw do
  root to: 'items#index'

  resources :merchants

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show'
  get '/items/:id/edit', to: 'items#edit'
  patch '/items/:id', to: 'items#update'
  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'
  delete '/items/:id', to: 'items#destroy'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  resources :users, only: [:create, :edit, :update, :show]
  get '/register', to: 'users#new'
  get '/users/:id/password_edit', to: 'users#password_edit'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    patch '/items/:item_id', to: 'items#toggle'
    get '/orders/:order_id', to: 'orders#show'
    resources :items
    patch '/itemorders/:id/fulfill', to: 'itemorders#fulfill'
    patch '/itemorders/:id', to: 'itemorders#cancel'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    patch '/orders/:order_id/ship', to: 'dashboard#ship'
    get '/users', to: 'users#index'
    patch '/merchants/:merchant_id', to: 'merchants#toggle'
    get '/merchants/:merchant_id', to: 'merchants#show'
    get '/users/:user_id', to: 'users#show'
  end

  namespace :user do
    resources :addresses
    get '/orders/new', to: 'orders#new'
    post '/orders', to: 'orders#create'
    get '/orders', to: 'orders#index'
    get '/orders/:id', to: 'orders#show'
    get '/orders/:id/edit', to: 'orders#edit'
    patch '/orders/:id', to: 'orders#update', as: :update
    put '/orders/:id', to: 'orders#cancel'
  end
end
