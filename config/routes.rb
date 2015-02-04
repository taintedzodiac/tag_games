TagGames::Application.routes.draw do
  get "pages/home"

  resources :votes do
    post 'post_score'
  end

  resources :games

  resources :time_slots

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :users

  # You can have the root of your site routed with "root"
  root 'pages#home'
end
