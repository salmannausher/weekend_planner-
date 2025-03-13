Rails.application.routes.draw do
  # Root path
  root "home#index"
  
  # User authentication with Devise
  devise_for :users
  
  # Google Calendar integration
  get "auth/google_oauth2/callback", to: "google_calendar#callback"
  get "calendar/connect", to: "google_calendar#connect", as: "connect_calendar"
  get "calendar/events", to: "google_calendar#events", as: "calendar_events"
  
  # Weekend plans
  resources :weekends do
    member do
      get :share
      post :finalize
    end
    
    # Nested resources
    resources :activities, only: [:create, :update, :destroy] do
      member do
        post :vote
      end
    end
    
    resources :comments, only: [:create, :destroy]
    
    # Weather forecasts - using a custom route instead of a resource with non-standard actions
    get "weather_forecasts/fetch", to: "weather_forecasts#fetch", as: "fetch_weather_forecasts"
  end
  
  # Public shared weekend view (no login required)
  get "shared/:token", to: "weekends#shared", as: "shared_weekend"
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
