Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root "walking_routes#index"
  resources :walking_routes, only: [:index, :show, :new, :create]
end
