Rails.application.routes.draw do
  root to: 'dashboards#index'

  resources :cards, except: [:index, :show]
  get '/cards/list', to: 'cards#list'

  resources :skills

  resources :dashboards
  get "dashboards/show_skill_charts/:skill_id", to: "dashboards#show_skill_charts", as: :show_skill_charts

  resources :users, except: [:index, :show]
  get 'users', to: 'users#new'
  get 'users/:id', to: 'users#edit'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
