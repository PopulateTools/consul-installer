Rails.application.routes.draw do

  root to: 'sites#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users, except: [:show]

  resources :servers do
    resources :server_setups, as: :setups, path: :setups,  only: [:index, :show, :create]
  end

  resources :sites do
    resources :site_deploys, as: :deploys, path: :deploys,  only: [:index, :show, :create]
    resources :site_setups, as: :setups, path: :setups,  only: [:index, :show, :create]
  end

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
