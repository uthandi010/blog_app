Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'home', to: 'home#index'

      resources :users, only: [:create]
      resources :profiles, only: [:show, :update]
      resources :sessions, only: [:create, :destroy] 
      resources :comments, only: [:create, :index, :destroy]
      resources :blog_posts, only: [:index, :show, :create, :update, :destroy] do
        resources :likes, only: [:create, :destroy]
      end
    end
  end
end
