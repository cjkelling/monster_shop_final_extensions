Rails.application.routes.draw do
  root to: 'items#index'

  resources :merchants
  resources :items, only: [:index, :show, :edit, :update]

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

  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
  get '/orders/:order_id', to: 'orders#show'
  patch '/orders/:order_id', to: 'orders#cancel'
  get '/profile/orders/:order_id', to: 'orders#show'
  get '/profile/orders', to: 'orders#index'

  resources :users
    match '/register', to: 'users#new', via: :get
    match '/users', to: 'users#create', via: :post
    match '/profile', to: 'users#show', via: :get
    match '/profile/edit', to: 'users#edit', via: :get
    match '/profile/password_edit', to: 'users#password_edit', via: :get
    match '/profile', to: 'users#update', via: :patch

  # get '/register', to: 'users#new'
  # post '/users', to: 'users#create'
  # get '/profile', to: 'users#show'
  # get '/profile/edit', to: 'users#edit'
  # get '/profile/password_edit', to: 'users#password_edit'
  # patch '/profile', to: 'users#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    patch '/items/:item_id', to: 'items#toggle'
    get '/orders/:order_id', to: 'orders#show'
    resources :items
    patch '/itemorders/:id/fulfill', to: 'itemorders#fulfill'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    patch '/orders/:order_id/ship', to: 'dashboard#ship'
    get '/users', to: 'users#index'
    patch '/merchants/:merchant_id', to: 'merchants#toggle'
    get '/merchants/:merchant_id', to: 'merchants#show'
  end
  get '/admin/users/:user_id', to: 'users#show'
end
