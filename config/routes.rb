Rails.application.routes.draw do
  devise_for :users
  root "walking_routes#index"
  resources :walking_routes, only: [:index, :show, :new, :create]
end
