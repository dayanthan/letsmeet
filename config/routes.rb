Rails.application.routes.draw do
  resources :users 
  resources :groups do
    resources :posts 
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
  get 'reply_comments/:id', to: 'posts#reply_comments', as: 'reply_comments'
  get 'all_reply_comments/:id', to: 'posts#all_reply_comments', as: 'all_reply_comments'
  post 'submit_reply', to: "posts#submit_reply", as: 'submit_reply'
  get 'pending_invitations/:id', to: "groups#pending_invitations", as: 'pending_invitations' 
  post 'invitation_status/:group_id/:id/:process', to: "groups#invitation_status", as: 'invitation_status' 
  post 'post_confirmation/:group_id/:id', to: "posts#post_confirmation", as: 'post_confirmation' 
  delete 'delet_post/:group_id/:id/', :to => 'posts#destroy', as: 'delet_post'

  root :to => "users#welcome"
end
