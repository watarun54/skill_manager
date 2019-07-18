Rails.application.routes.draw do
  get '/cards', to: 'cards#index'
  get '/cards/list', to: 'cards#list'
end
