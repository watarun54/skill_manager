Rails.application.routes.draw do
  resources :cards, except: [:show]
  get '/cards/list', to: 'cards#list'

  resources :skills
end
