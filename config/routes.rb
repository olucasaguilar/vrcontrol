Rails.application.routes.draw do
  root "home#index"

  # Rotas dentro de Cadastros Extras
  resources :entity_types, except: [:show]
  resources :fabric_types, except: [:show]
  resources :colors, except: [:show]
  resources :garment_types, except: [:show]
  resources :garment_sizes, except: [:show]


  # Rotas de Entidades
  get '/entidades', to: 'entities#index', as: 'entidades'
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
  get '/tecidos/entrada', to: 'fabric_entries#new', as: 'new_fabric_entry'
  post '/tecidos/entrada', to: 'fabric_entries#create', as: 'create_fabric_entry'
  get '/tecidos/entrada/detalhes', to: 'fabric_entries#new_details', as: 'new_fabric_entry_details'
  post '/tecidos/entrada/detalhes', to: 'fabric_entries#create_details', as: 'create_fabric_entry_details'

  # Rota para tela de estoque
  get '/estoque', to: 'stock#index', as: 'stock'

  # Rota para tela temporária de caixa
  get '/caixa/temp_view', to: 'financial_records#temp_view', as: 'temp_view_financial_records'
  # Rota para tela temporária estoque tecidos
  get '/estoque/tecidos/temp_view', to: 'stock#tecidos_temp_view', as: 'tecidos_temp_view_stock'
  # Rota para tela temporária estoque peças
  get '/estoque/pecas/temp_view', to: 'stock#pecas_temp_view', as: 'pecas_temp_view_stock'
  # Rota para tela temporária corte envio
  get '/temp_view/corte/envio', to: 'temp_views#corte_envio', as: 'temp_view_corte_envio'
  # Rota para tela temporária corte retorno
  get '/temp_view/corte/retorno', to: 'temp_views#corte_retorno', as: 'temp_view_corte_retorno'
  # Rota para tela temporária serigrafia
  get '/temp_view/serigrafia', to: 'temp_views#serigrafia', as: 'temp_view_serigrafia'
  # Rota para tela temporária costura
  get '/temp_view/costura', to: 'temp_views#costura', as: 'temp_view_costura'
  # Rota para tela temporária acabamento
  get '/temp_view/acabamento', to: 'temp_views#acabamento', as: 'temp_view_acabamento'
  # Rota para tela temporária venda
  get '/temp_view/venda', to: 'temp_views#venda', as: 'temp_view_venda'
  # Rota para tela temporária login
  get '/temp_view/login', to: 'temp_views#login', as: 'temp_view_login'
end
