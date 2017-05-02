Rails.application.routes.draw do
  resources :events, :users
  root 'events#index'

  post '/drop', to: 'users#drop'
  get '/search', to: 'events#search'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/settings', to: 'users#edit'
  get '/error', to: 'users#error'
  get 'events/new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/charges', to: 'charges#new'
  post '/charges', to: 'charges#create'
  post 'tokens' => "tokens#create"



end
