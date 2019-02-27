Rails.application.routes.draw do
  resources :users 
  # do
  #   member do
  #     get :confirm_email
  #   end
  # end
  match '/users/confirm_email/:token', to: 'users#confirm_email', via: :get, as: :confirm_email

  resources :groups
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'welcome', to: 'users#welcome', as: 'welcome' 
  get 'add_members/:id', to: 'groups#add_members', as: 'add_members'
  root :to => "users#welcome"
end
