Rails.application.routes.draw do
  root "home#index"
  get '/cadastros_extras', to: 'cadastros_extras#index', as: 'cadastros_extras'
  resources :entity_types, except: [:show]
end
