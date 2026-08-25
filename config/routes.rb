Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "application#index"
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resource :family, only: [:edit, :update]
  resolve('Family') { [:family] }
  get 'family/created', to: 'families#created', as: :created_family
  resources :items, only: [:create, :update, :destroy] do
    resources :purchases, only: [:create, :destroy]
  end
  get 'items/:item_id/purchases/conflict', to: 'purchases#conflict', as: :purchase_conflict

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
