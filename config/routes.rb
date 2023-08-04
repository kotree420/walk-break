Rails.application.routes.draw do
  root "walking_routes#home"
  devise_for :users

  resources :profiles, only: [:show, :edit, :update] do
    collection do
      patch 'withdrawal'
    end
  end
  resources :walking_routes do
    collection do
      get 'search'
    end
    resource :bookmarks, only: [:create, :destroy]
  end
end
