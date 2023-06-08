Rails.application.routes.draw do
  # 管理者
  devise_for :admins, controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: 'posts#index'
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
    get 'customers/confirm_deleted' => 'users#confirm_deleted', as: 'confirm_deleted'
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