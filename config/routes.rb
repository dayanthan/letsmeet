Rails.application.routes.draw do
  resources :users 
  resources :groups do
    resources :posts do
       resources :comments
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :posts do
       resources :comments
  end
  match '/users/confirm_email/:token', to: 'users#confirm_email', via: :get, as: :confirm_email
  match '/groups/accept_invitation/:token', to: 'groups#accept_invitation', via: :get, as: :accept_invitation
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'welcome', to: 'users#welcome', as: 'welcome' 
  get 'add_members/:id', to: 'groups#add_members', as: 'add_members'
  post 'send_invite/:group_id/:user_id', to: "groups#send_invite", as: 'send_invite'
  get 'all_posts', to: 'posts#all_posts', as: 'all_posts'
  root :to => "users#welcome"
end
