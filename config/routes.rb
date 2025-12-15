Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/home" => "application#home", as: :home
  resources :products do
    resources :subscribers, only: [:create]
  end
  resource :unsubscribe, only: [:show]
  resources :subscriptions, only: [:index, :show, :destroy, :create, :new] do
    post "/unsubscribe", to: "subscriptions#unsubscribe"
    resources :shipments
  end

  get "/shipments" => "shipments#all", as: :shipments

  resources :users do
    get "/subscriptions", to: "subscriptions#index_by_user"
    get "/shipments", to: "shipments#index_by_user"
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "application#home"
end
