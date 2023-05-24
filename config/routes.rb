Rails.application.routes.draw do
  root "walking_routes#index"
  resources :walking_routes, only: [:index, :new, :create]
end
