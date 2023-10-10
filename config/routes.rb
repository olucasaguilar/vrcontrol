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
  get '/caixa/new', to: 'financial_records#new', as: 'new_financial_record'
  post '/caixa', to: 'financial_records#create', as: 'create_financial_record'

  # Rotas de Entrada Tecido
  get '/tecidos/entrada', to: 'fabric_entries#new', as: 'new_fabric_entry'
  post '/tecidos/entrada', to: 'fabric_entries#create', as: 'create_fabric_entry'
  get '/tecidos/entrada/detalhes', to: 'fabric_entries#new_details', as: 'new_fabric_entry_details'
  post '/tecidos/entrada/detalhes', to: 'fabric_entries#create_details', as: 'create_fabric_entry_details'

  # Rota para tela de estoque
  get '/estoque/tecidos', to: 'stock#tecidos_view', as: 'tecidos_view_stock'
  get '/estoque/pecas', to: 'stock#pecas_view', as: 'pecas_view_stock'

  # Rota para tela de Corte
  get '/corte/envio', to: 'fabric_cuts#new', as: 'new_fabric_cut'
  post '/corte/envio', to: 'fabric_cuts#create', as: 'create_fabric_cut'
  get '/corte/envio/detalhes', to: 'fabric_cuts#new_details', as: 'new_fabric_cut_details'
  post '/corte/envio/detalhes', to: 'fabric_cuts#create_details', as: 'create_fabric_cut_details'
  get 'get_colors_for_fabric_type', to: 'fabric_cuts#get_colors_for_fabric_type'
  get 'get_total_quantity_for_color', to: 'fabric_cuts#get_total_quantity_for_color'
  get '/corte/retorno', to: 'fabric_cuts#return', as: 'return_fabric_cut'
  get '/corte/retorno/:id', to: 'fabric_cuts#return_details', as: 'return_fabric_cut_details'
  post '/corte/retorno', to: 'fabric_cuts#create_fabric_cut_return', as: 'create_fabric_cut_return'

  # Rota para tela temporária corte envio
  get '/temp_view/corte/envio', to: 'temp_views#corte_envio', as: 'temp_view_corte_envio'
  # Rota para tela temporária corte retorno
  get '/temp_view/corte/retorno', to: 'temp_views#corte_retorno', as: 'temp_view_corte_retorno'
  # Rota para tela temporária serigrafia envio
  get '/temp_view/serigrafia/envio', to: 'temp_views#serigrafia_envio', as: 'temp_view_serigrafia_envio'
  # Rota para tela temporária serigrafia retorno
  get '/temp_view/serigrafia/retorno', to: 'temp_views#serigrafia_retorno', as: 'temp_view_serigrafia_retorno'
  # Rota para tela temporária costura envio
  get '/temp_view/costura/envio', to: 'temp_views#costura_envio', as: 'temp_view_costura_envio'
  # Rota para tela temporária costura retorno
  get '/temp_view/costura/retorno', to: 'temp_views#costura_retorno', as: 'temp_view_costura_retorno'
  # Rota para tela temporária acabamento envio
  get '/temp_view/acabamento/envio', to: 'temp_views#acabamento_envio', as: 'temp_view_acabamento_envio'
  # Rota para tela temporária acabamento retorno
  get '/temp_view/acabamento/retorno', to: 'temp_views#acabamento_retorno', as: 'temp_view_acabamento_retorno'
  # Rota para tela temporária venda saida
  get '/temp_view/venda/saida', to: 'temp_views#venda_saida', as: 'temp_view_venda_saida'
  # Rota para tela temporária venda retorno
  get '/temp_view/venda/retorno', to: 'temp_views#venda_retorno', as: 'temp_view_venda_retorno'
  # Rota para tela temporária login
  get '/temp_view/login', to: 'temp_views#login', as: 'temp_view_login'
end
