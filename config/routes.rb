Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  post 'atualizar_menu_status', to: 'application#atualizar_menu_status'

  # Rotas dentro de Cadastros Extras
  resources :entity_types, except: [:show]
  resources :fabric_types, except: [:show]
  resources :colors, except: [:show]
  resources :garment_types, except: [:show]
  resources :garment_sizes, except: [:show]

  # Rotas de Entidades
  get '/entidades', to: 'entities#index', as: 'entidades'
  get '/entities/:id/edit', to: 'entities#edit', as: 'edit_entity'
  get '/entities/:id', to: 'entities#show', as: 'entity'
  patch '/entities/:id', to: 'entities#update', as: 'update_entity'
  delete '/entities/:id', to: 'entities#destroy', as: 'destroy_entity'
  get '/entity/new/:id', to: 'entities#new', as: 'new_entity'
  get '/entities', to: 'entities#show', as: 'entities'
  post '/entities', to: 'entities#create', as: 'create_entity'
  patch '/entities/:id/toggle_status', to: 'entities#toggle_status', as: 'toggle_status_entity'
  get '/entidades/inativos', to: 'entities#inactives', as: 'entity_inactives'

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
  get '/estoque/tecidos',         to: 'stock#tecidos_view', as: 'tecidos_view_stock'
  get '/estoque/pecas',           to: 'stock#pecas_view', as: 'pecas_view_stock'
  get '/estoque/pecas_acabadas',  to: 'stock#pecas_acabadas_view', as: 'pecas_acabadas_view_stock'

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

  # Rota para tela de serigrafia 
  get '/serigrafia/envio', to: 'screen_printing#new', as: 'new_screen_printing'
  post '/serigrafia/envio', to: 'screen_printing#create', as: 'create_screen_printing'
  get '/serigrafia/envio/detalhes', to: 'screen_printing#new_details', as: 'new_screen_printing_details'
  post '/serigrafia/envio/detalhes', to: 'screen_printing#create_details', as: 'create_screen_printing_details'
  get 'get_total_quantity_costurada', to: 'screen_printing#get_total_quantity_costurada'
  get '/serigrafia/retorno', to: 'screen_printing#return', as: 'return_screen_printing'
  get '/serigrafia/retorno/:id', to: 'screen_printing#return_details', as: 'return_screen_printing_details'
  post '/serigrafia/retorno', to: 'screen_printing#create_screen_printing_return', as: 'create_screen_printing_return'
  
  # Rota para tela de costura 
  get '/costura/envio', to: 'sewing#new', as: 'new_sewing'
  post '/costura/envio', to: 'sewing#create', as: 'create_sewing'
  get '/costura/envio/detalhes', to: 'sewing#new_details', as: 'new_sewing_details'
  post '/costura/envio/detalhes', to: 'sewing#create_details', as: 'create_sewing_details'
  get 'get_total_quantity_estampada', to: 'sewing#get_total_quantity_estampada'
  get '/costura/retorno', to: 'sewing#return', as: 'return_sewing'
  get '/costura/retorno/:id', to: 'sewing#return_details', as: 'return_sewing_details'
  post '/costura/retorno', to: 'sewing#create_sewing_return', as: 'create_sewing_return'
  
  # Rota para tela de acabamento 
  get '/acabamento/envio',                  to: 'finishing#new',                      as: 'new_finishing'
  post '/acabamento/envio',                 to: 'finishing#create',                   as: 'create_finishing'
  get '/acabamento/envio/detalhes',         to: 'finishing#new_details',              as: 'new_finishing_details'
  post '/acabamento/envio/detalhes',        to: 'finishing#create_details',           as: 'create_finishing_details'
  get 'get_total_quantity_estampada_acab',  to: 'finishing#get_total_quantity_estampada'
  get '/acabamento/retorno',                to: 'finishing#return',                   as: 'return_finishing'
  get '/acabamento/retorno/:id',            to: 'finishing#return_details',           as: 'return_finishing_details'
  post '/acabamento/retorno',               to: 'finishing#create_finishing_return',  as: 'create_finishing_return'
  
  # Rotas para cadastro de usuário
  get   '/cadastro_usuario',                   to: 'users#home',             as: 'cadastro_usuario'
  get   '/deslogar',                           to: 'users#destroy_session',  as: 'destroy_session'
  get   '/cadastro_usuario/perfil',            to: 'users#profile',          as: 'my_profile'
  post  '/cadastro_usuario/perfil',            to: 'users#update',           as: 'update_profile'
  get   '/cadastro_usuario/admin/novo',        to: 'users#new',              as: 'new_user'
  post  '/cadastro_usuario/admin/novo',        to: 'users#create',           as: 'create_user'
  get   '/cadastro_usuario/admin/todos',       to: 'users#index',            as: 'index_users'
  get   '/cadastro_usuario/admin/:id/edit/',   to: 'users#edit',             as: 'admin_edit'
  post  '/cadastro_usuario/admin/:id/edit/',   to: 'users#admin_update',     as: 'admin_update'
  
  # Rotas para Venda
  get '/venda/saida', to: 'sales#new', as: 'new_sale'
  post '/venda/saida', to: 'sales#create', as: 'create_new_sales'
  get '/venda/retorno', to: 'sales#return', as: 'return_sale'
  post '/venda/retorno', to: 'sales#create_return', as: 'create_return_sale'
  get 'get_total_quantity_finished', to: 'sales#get_total_quantity_finished'
end
