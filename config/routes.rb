Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      resources :test, only: %i[index]

      resources :users, only: %i[show]      
      resources :notifications, only: %i[index] do
        collection do
          get 'observe'
        end
      end
      resources :relationships, only: %i[index create destroy]
      resources :posts, only: %i[index show create update destroy] do
        resources :comments, only: %i[create destroy]
        resources :likes, only: %i[index create destroy]

        # 検索機能用（現状保留にしてる。）
        collection do
          get 'search'
        end
      end

      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }
      namespace :auth do
        resources :sessions, only: %i[index] 
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
