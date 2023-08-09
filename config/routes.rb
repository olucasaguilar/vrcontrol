Rails.application.routes.draw do
  root "home#index"

  get '/cadastros_extras', to: 'cadastros_extras#index', as: 'cadastros_extras'

  resources :entity_types, except: [:show]
  resources :fabric_types, except: [:show]

  # Listar entidades por tipo
  get '/entities-by-type', to: 'entities#entities_by_type', as: 'entities_by_type'
  # Filtrar entidades por tipo
  get '/entities-by-type/:entity_type_id', to: 'entities#filter_by_type', as: 'filter_by_type'
  # Editar uma entidade
  get '/entities/:id/edit', to: 'entities#edit', as: 'edit_entity'
  # Exibir detalhes de uma entidade
  get '/entities/:id', to: 'entities#show', as: 'entity'
  # Atualizar uma entidade
  patch '/entities/:id', to: 'entities#update', as: 'update_entity'
  # Excluir uma entidade
  delete '/entities/:id', to: 'entities#destroy', as: 'destroy_entity'
  # Criar uma nova entidade
  get '/entity/new/:id', to: 'entities#new', as: 'new_entity'
  # Listar todas as entidades
  get '/entities', to: 'entities#show', as: 'entities'
  # Criar uma nova entidade
  post '/entities', to: 'entities#create', as: 'create_entity'

  #
  get '/caixa', to: 'financial_records#index', as: 'financial_records'
end
