Rails.application.routes.draw do
  root to: 'events#index'
  devise_for :users
  resources :events do
    get :join, to: 'events#join', as: :join
  end
  get 'tags/:tag', to: 'events#index', as: :tag
end
