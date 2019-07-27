Rails.application.routes.draw do
  root to: 'dashboards#index'

  resources :cards, except: [:index, :show]
  get '/cards/list', to: 'cards#list'

  resources :skills

  resources :dashboards

  get 'users', to: 'users#new'
	post 'users', to: 'users#create'
	get 'users/new', to: 'users#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
