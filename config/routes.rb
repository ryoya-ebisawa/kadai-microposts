Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create] do
    member do
      get :followings
      get :followers
      get :favoritings
      get :likes
    end
    #collection do
    #  get :search
    #end
  end

  resources :microposts, only: [:create, :destroy] do
    member do
      get :favoriters
    end
  end
  
  #フォロー、アンフォロー
  resources :relationships, only: [:create, :destroy]
  
  #favorite/unfavorite
  resources :favorites, only: [:create, :destroy]
end