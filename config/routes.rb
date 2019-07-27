Rails.application.routes.draw do
  root to: 'dashboards#index'

  resources :cards, except: [:index, :show]
  get '/cards/list', to: 'cards#list'

  resources :skills

  resources :dashboards

	get 'users/new' => 'users#new'
	post 'users' => 'users#create'

  # get 'login', to: 'sessions#new'
  # post 'login', to: 'sessions#create'
  # delete 'logout', to: 'sessions#destroy'
end
