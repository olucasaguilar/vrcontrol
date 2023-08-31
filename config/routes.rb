Rails.application.routes.draw do
  root "home#index"
  get '/cadastros_extras', to: 'cadastros_extras#index', as: 'cadastros_extras'

  # Rotas dentro de Cadastros Extras
  resources :entity_types, except: [:show]
  resources :fabric_types, except: [:show]
  resources :colors, except: [:show]
  resources :garment_types, except: [:show]
  resources :garment_sizes, except: [:show]

  # Rotas de Entidades
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

  # Rotas de Caixa
  get '/caixa', to: 'financial_records#index', as: 'financial_records'
  # Rota para criar uma nova movimentação de caixa
  get '/caixa/new', to: 'financial_records#new', as: 'new_financial_record'
  # Rota para criar uma nova movimentação de caixa
  post '/caixa', to: 'financial_records#create', as: 'create_financial_record'

  # Rotas de Entrada Tecido
  # /tecidos/entrada - primeira tela de criar nova entrada
  # /tecidos/entrada/detalhes - segunda tela de criar nova entrada
  get '/tecidos/entrada', to: 'fabric_entries#new', as: 'new_fabric_entry'
  post '/tecidos/entrada', to: 'fabric_entries#create', as: 'create_fabric_entry'
  # Rota delete temporária
  delete '/tecidos/entrada', to: 'fabric_entries#destroy_all', as: 'delete_all_fabric_entries'
  #get '/tecidos/entrada/detalhes', to: 'fabric_entries#new_details', as: 'new_fabric_entry_details'
end
