Rails.application.routes.draw do
  # 静态页面
  get 'privacy', to: 'pages#privacy'
  get 'terms',   to: 'pages#terms'
  get 'pricing', to: 'pricing#index', as: :pricing
  
  devise_for :users, 
             class_name: 'Sys::User', 
             path: '',
             controllers: {
               registrations: 'sys/registrations',
               sessions: 'sys/sessions'
             },
             path_names: { 
               sign_in: 'login', 
               sign_up: 'register' 
             }

  # 管理员后台
  namespace :admin do
    root "dashboard#index"
    resources :users, only: [:index, :update, :destroy] do
      member do
        patch :toggle_vip
      end
    end
    resources :carousel_items
    resources :posts
    resources :activities
    resources :categories
    resources :sites
  end

  # 会员展示页
  resources :members, only: [:show] do
    member do
      get :card
    end
  end
  resource :profile, only: [:edit, :update]
  resources :posts, only: [:index, :show]
  resources :activities, only: [:index, :show]
  get 'user_card', to: 'home#user_card'

  # Defines the root path route ("/")
  root "home#index"


  get "up" => "rails/health#show", as: :rails_health_check
end
