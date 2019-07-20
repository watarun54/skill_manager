Rails.application.routes.draw do
  resources :cards, only: [:index, :new, :create, :destroy]
  get '/cards/list', to: 'cards#list'
end
