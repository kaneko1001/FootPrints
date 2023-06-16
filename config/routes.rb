Rails.application.routes.draw do
  # 管理者
  devise_for :admin, controllers: {
    sessions: 'admins/sessions'
  }

  namespace :admins do
    root to: 'customers#index'
    get 'search' => 'searches#search'
    resources :customers, only: [:index, :show, :edit, :update]
    resources :posts, only: [:show, :destroy] do
      resources :comments, only: [:destroy]
    end
  end

  # ユーザー用
  devise_for :customers, controllers: {
    registrations: "customers/registrations",
    sessions: "customers/sessions"
  }

  scope module: :customers do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    get 'search' => 'searches#search'
    get 'check' => 'customers#check'
    patch 'customers/withdrawal' => 'customers#withdrawal', as: 'customers_withdrawal'
    resources :customers, only: [:index, :show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    resources :posts do
      get :favorites, on: :collection
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end