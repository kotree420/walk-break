Rails.application.routes.draw do
  root "walking_routes#index"
  devise_for :users

  resources :profiles, only: [:show, :edit, :update] do
    collection do
      patch 'withdrawal'
    end
  end
  resources :walking_routes do
    resource :bookmarks, only: [:create, :destroy]
  end
end
