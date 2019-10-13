Rails.application.routes.draw do
  root to: 'general_skills#index'

  resources :cards, except: [:index, :show] do
    put :sort
  end
  get '/cards/list', to: 'cards#list'
  get '/cards/search', to: 'cards#search'

  resources :lists
  get '/lists/:id/new_card', to: 'lists#new_card', as: :new_list_card
  post '/lists/:id/create_card', to: 'lists#create_card', as: :create_list_card

  resources :general_skills
  get "general_skills/show_skill_charts/:id/:skill_id", to: "general_skills#show_skill_charts", as: :show_skill_charts

  resources :skills, except: :show
  get '/skills/search', to: 'skills#search'

  resources :papers, except: :show

  resources :dashboards
  # get "dashboards/show_skill_charts/:skill_id", to: "dashboards#show_skill_charts", as: :show_skill_charts

  resources :users, except: [:index, :show]
  get 'users', to: 'users#new'
  get 'users/:id', to: 'users#edit'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  post 'linebot/callback', to: 'linebot#callback'
end
