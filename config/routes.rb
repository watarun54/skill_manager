Rails.application.routes.draw do
  root to: 'dashboards#index'

  resources :cards, except: [:index, :show]
  get '/cards/list', to: 'cards#list'

  resources :skills

  resources :dashboards
end
