# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_15_215742) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colors", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entities", force: :cascade do |t|
    t.string "nome"
    t.string "num_contato"
    t.string "cidade"
    t.string "estado"
    t.bigint "entity_types_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cnpj"
    t.string "ie"
    t.integer "status", default: 1
    t.string "cpf"
    t.boolean "juridica", default: false
    t.index ["entity_types_id"], name: "index_entities_on_entity_types_id"
  end

  create_table "entity_types", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fabric_cut_garment_sizes", force: :cascade do |t|
    t.bigint "tecido_corte_peca_id", null: false
    t.integer "qtd_tamanho"
    t.bigint "tamanho_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tamanho_id"], name: "index_fabric_cut_garment_sizes_on_tamanho_id"
    t.index ["tecido_corte_peca_id"], name: "index_fabric_cut_garment_sizes_on_tecido_corte_peca_id"
  end

  create_table "fabric_cut_garments", force: :cascade do |t|
    t.bigint "estoque_pecas_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "saida_tecido_estoque_id"
    t.index ["estoque_pecas_id"], name: "index_fabric_cut_garments_on_estoque_pecas_id"
    t.index ["saida_tecido_estoque_id"], name: "index_fabric_cut_garments_on_saida_tecido_estoque_id"
  end

  create_table "fabric_cuts", force: :cascade do |t|
    t.datetime "data_hora_ida"
    t.decimal "total_tecido_envio"
    t.decimal "total_peca_retorno"
    t.boolean "finalizado"
    t.datetime "data_hora_volta"
    t.bigint "cortador_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cortador_id"], name: "index_fabric_cuts_on_cortador_id"
  end

  create_table "fabric_entries", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.datetime "data_hora"
    t.decimal "total_tecido"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_fabric_entries_on_entity_id"
  end

  create_table "fabric_stock_entries", force: :cascade do |t|
    t.bigint "entrada_tecido_id", null: false
    t.bigint "estoque_tecido_id", null: false
    t.decimal "valor_tecido"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entrada_tecido_id"], name: "index_fabric_stock_entries_on_entrada_tecido_id"
    t.index ["estoque_tecido_id"], name: "index_fabric_stock_entries_on_estoque_tecido_id"
  end

  create_table "fabric_stock_exits", force: :cascade do |t|
    t.bigint "tecido_corte_id", null: false
    t.bigint "estoque_tecido_id", null: false
    t.float "multiplicador"
    t.float "rendimento"
    t.bigint "tipo_peca_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_tecido_id"], name: "index_fabric_stock_exits_on_estoque_tecido_id"
    t.index ["tecido_corte_id"], name: "index_fabric_stock_exits_on_tecido_corte_id"
    t.index ["tipo_peca_id"], name: "index_fabric_stock_exits_on_tipo_peca_id"
  end

  create_table "fabric_stocks", force: :cascade do |t|
    t.bigint "tipo_tecido_id", null: false
    t.bigint "cor_id", null: false
    t.decimal "quantidade"
    t.string "tipo_movimento"
    t.datetime "data_hora"
    t.decimal "saldo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cor_id"], name: "index_fabric_stocks_on_cor_id"
    t.index ["tipo_tecido_id"], name: "index_fabric_stocks_on_tipo_tecido_id"
  end

  create_table "fabric_types", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "financial_fabric_cuts", force: :cascade do |t|
    t.bigint "registro_financeiro_id", null: false
    t.bigint "tecido_corte_id", null: false
    t.boolean "retorno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registro_financeiro_id"], name: "index_financial_fabric_cuts_on_registro_financeiro_id"
    t.index ["tecido_corte_id"], name: "index_financial_fabric_cuts_on_tecido_corte_id"
  end

  create_table "financial_fabric_entries", force: :cascade do |t|
    t.bigint "registro_financeiro_id", null: false
    t.bigint "entrada_tecido_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entrada_tecido_id"], name: "index_financial_fabric_entries_on_entrada_tecido_id"
    t.index ["registro_financeiro_id"], name: "index_financial_fabric_entries_on_registro_financeiro_id"
  end

  create_table "financial_garment_finishings", force: :cascade do |t|
    t.bigint "registro_financeiro_id", null: false
    t.bigint "peca_acabamento_id", null: false
    t.boolean "retorno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_acabamento_id"], name: "index_financial_garment_finishings_on_peca_acabamento_id"
    t.index ["registro_financeiro_id"], name: "index_financial_garment_finishings_on_registro_financeiro_id"
  end

  create_table "financial_garment_return_sales", force: :cascade do |t|
    t.bigint "registro_financeiro_id", null: false
    t.bigint "peca_venda_retorno_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_venda_retorno_id"], name: "index_financial_garment_return_sales_on_peca_venda_retorno_id"
    t.index ["registro_financeiro_id"], name: "index_financial_garment_return_sales_on_registro_financeiro_id"
  end

  create_table "financial_garment_sewings", force: :cascade do |t|
    t.bigint "registro_financeiro_id", null: false
    t.bigint "peca_costura_id", null: false
    t.boolean "retorno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_costura_id"], name: "index_financial_garment_sewings_on_peca_costura_id"
    t.index ["registro_financeiro_id"], name: "index_financial_garment_sewings_on_registro_financeiro_id"
  end

  create_table "financial_records", force: :cascade do |t|
    t.decimal "valor"
    t.decimal "saldo"
    t.string "tipo_movimento"
    t.string "observacao"
    t.datetime "data_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "financial_screens_printings", force: :cascade do |t|
    t.bigint "registro_financeiro_id", null: false
    t.bigint "peca_serigrafia_id", null: false
    t.boolean "retorno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_serigrafia_id"], name: "index_financial_screens_printings_on_peca_serigrafia_id"
    t.index ["registro_financeiro_id"], name: "index_financial_screens_printings_on_registro_financeiro_id"
  end

  create_table "garment_finished_stocks", force: :cascade do |t|
    t.bigint "tipo_peca_id", null: false
    t.integer "quantidade"
    t.string "tipo_movimento"
    t.datetime "data_hora"
    t.integer "saldo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tipo_peca_id"], name: "index_garment_finished_stocks_on_tipo_peca_id"
  end

  create_table "garment_finishing_garments", force: :cascade do |t|
    t.bigint "estoque_pecas_acabada_id", null: false
    t.bigint "saida_peca_estoque_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_pecas_acabada_id"], name: "index_garment_finishing_garments_on_estoque_pecas_acabada_id"
    t.index ["saida_peca_estoque_id"], name: "index_garment_finishing_garments_on_saida_peca_estoque_id"
  end

  create_table "garment_finishing_sizes", force: :cascade do |t|
    t.bigint "peca_acabamento_peca_id", null: false
    t.integer "qtd_tamanho"
    t.bigint "tamanho_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_acabamento_peca_id"], name: "index_garment_finishing_sizes_on_peca_acabamento_peca_id"
    t.index ["tamanho_id"], name: "index_garment_finishing_sizes_on_tamanho_id"
  end

  create_table "garment_finishing_stock_exits", force: :cascade do |t|
    t.bigint "peca_acabamento_id", null: false
    t.bigint "estoque_peca_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_peca_id"], name: "index_garment_finishing_stock_exits_on_estoque_peca_id"
    t.index ["peca_acabamento_id"], name: "index_garment_finishing_stock_exits_on_peca_acabamento_id"
  end

  create_table "garment_finishings", force: :cascade do |t|
    t.bigint "acabamento_id", null: false
    t.datetime "data_hora_ida"
    t.decimal "total_pecas_envio"
    t.decimal "total_pecas_retorno"
    t.boolean "finalizado"
    t.datetime "data_hora_volta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acabamento_id"], name: "index_garment_finishings_on_acabamento_id"
  end

  create_table "garment_sale_exits", force: :cascade do |t|
    t.bigint "vendedor_id", null: false
    t.datetime "data_hora"
    t.decimal "total_pecas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vendedor_id"], name: "index_garment_sale_exits_on_vendedor_id"
  end

  create_table "garment_sale_returns", force: :cascade do |t|
    t.bigint "vendedor_id", null: false
    t.datetime "data_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vendedor_id"], name: "index_garment_sale_returns_on_vendedor_id"
  end

  create_table "garment_sale_stock_exits", force: :cascade do |t|
    t.bigint "peca_venda_saida_id", null: false
    t.bigint "estoque_pecas_acabadas_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_pecas_acabadas_id"], name: "index_garment_sale_stock_exits_on_estoque_pecas_acabadas_id"
    t.index ["peca_venda_saida_id"], name: "index_garment_sale_stock_exits_on_peca_venda_saida_id"
  end

  create_table "garment_screen_garment_sizes", force: :cascade do |t|
    t.bigint "peca_serigrafia_peca_id", null: false
    t.integer "qtd_tamanho"
    t.bigint "tamanho_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_serigrafia_peca_id"], name: "index_garment_screen_garment_sizes_on_peca_serigrafia_peca_id"
    t.index ["tamanho_id"], name: "index_garment_screen_garment_sizes_on_tamanho_id"
  end

  create_table "garment_screen_garments", force: :cascade do |t|
    t.bigint "estoque_pecas_id", null: false
    t.bigint "saida_peca_serigrafia_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_pecas_id"], name: "index_garment_screen_garments_on_estoque_pecas_id"
    t.index ["saida_peca_serigrafia_id"], name: "index_garment_screen_garments_on_saida_peca_serigrafia_id"
  end

  create_table "garment_screen_printing_stock_exits", force: :cascade do |t|
    t.bigint "peca_serigrafia_id", null: false
    t.bigint "estoque_peca_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_peca_id"], name: "index_garment_screen_printing_stock_exits_on_estoque_peca_id"
    t.index ["peca_serigrafia_id"], name: "index_garment_screen_printing_stock_exits_on_peca_serigrafia_id"
  end

  create_table "garment_screen_printings", force: :cascade do |t|
    t.bigint "serigrafia_id", null: false
    t.datetime "data_hora_ida"
    t.decimal "total_pecas_envio"
    t.decimal "total_pecas_retorno"
    t.boolean "finalizado"
    t.datetime "data_hora_volta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serigrafia_id"], name: "index_garment_screen_printings_on_serigrafia_id"
  end

  create_table "garment_sewing_garment_sizes", force: :cascade do |t|
    t.bigint "peca_costura_peca_id", null: false
    t.integer "qtd_tamanho"
    t.bigint "tamanho_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_costura_peca_id"], name: "index_garment_sewing_garment_sizes_on_peca_costura_peca_id"
    t.index ["tamanho_id"], name: "index_garment_sewing_garment_sizes_on_tamanho_id"
  end

  create_table "garment_sewing_garments", force: :cascade do |t|
    t.bigint "estoque_pecas_id", null: false
    t.bigint "saida_peca_estoque_costura_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_pecas_id"], name: "index_garment_sewing_garments_on_estoque_pecas_id"
    t.index ["saida_peca_estoque_costura_id"], name: "index_garment_sewing_garments_on_saida_peca_estoque_costura_id"
  end

  create_table "garment_sewing_stock_exits", force: :cascade do |t|
    t.bigint "peca_costura_id", null: false
    t.bigint "estoque_peca_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estoque_peca_id"], name: "index_garment_sewing_stock_exits_on_estoque_peca_id"
    t.index ["peca_costura_id"], name: "index_garment_sewing_stock_exits_on_peca_costura_id"
  end

  create_table "garment_sewings", force: :cascade do |t|
    t.datetime "data_hora_ida"
    t.decimal "total_pecas_envio"
    t.decimal "total_pecas_retorno"
    t.boolean "finalizado"
    t.datetime "data_hora_volta"
    t.bigint "costureira_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["costureira_id"], name: "index_garment_sewings_on_costureira_id"
  end

  create_table "garment_sizes", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "garment_stock_entries", force: :cascade do |t|
    t.bigint "saida_peca_acabada_id", null: false
    t.bigint "peca_venda_retorno_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["peca_venda_retorno_id"], name: "index_garment_stock_entries_on_peca_venda_retorno_id"
    t.index ["saida_peca_acabada_id"], name: "index_garment_stock_entries_on_saida_peca_acabada_id"
  end

  create_table "garment_stocks", force: :cascade do |t|
    t.bigint "tipo_peca_id", null: false
    t.boolean "costurada"
    t.boolean "estampada"
    t.integer "quantidade"
    t.string "tipo_movimento"
    t.datetime "data_hora"
    t.integer "saldo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tipo_peca_id"], name: "index_garment_stocks_on_tipo_peca_id"
  end

  create_table "garment_types", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "admin", default: false
    t.boolean "entities", default: false
    t.boolean "entities_create", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "financial", default: false
    t.boolean "financial_create", default: false
    t.boolean "fabric_stock", default: false
    t.boolean "garment_stock", default: false
    t.boolean "finished_garment_stock", default: false
    t.boolean "fabric_entry", default: false
    t.boolean "fabric_cut", default: false
    t.boolean "fabric_cut_return", default: false
    t.boolean "screen_print", default: false
    t.boolean "screen_print_return", default: false
    t.boolean "sewing", default: false
    t.boolean "sewing_return", default: false
    t.boolean "finishing", default: false
    t.boolean "finishing_return", default: false
    t.boolean "sales", default: false
    t.boolean "sales_return", default: false
    t.boolean "extras", default: false
    t.boolean "relatorio", default: false
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "entities", "entity_types", column: "entity_types_id"
  add_foreign_key "fabric_cut_garment_sizes", "fabric_cut_garments", column: "tecido_corte_peca_id"
  add_foreign_key "fabric_cut_garment_sizes", "garment_sizes", column: "tamanho_id"
  add_foreign_key "fabric_cut_garments", "fabric_stock_exits", column: "saida_tecido_estoque_id"
  add_foreign_key "fabric_cut_garments", "garment_stocks", column: "estoque_pecas_id"
  add_foreign_key "fabric_cuts", "entities", column: "cortador_id"
  add_foreign_key "fabric_entries", "entities"
  add_foreign_key "fabric_stock_entries", "fabric_entries", column: "entrada_tecido_id"
  add_foreign_key "fabric_stock_entries", "fabric_stocks", column: "estoque_tecido_id"
  add_foreign_key "fabric_stock_exits", "fabric_cuts", column: "tecido_corte_id"
  add_foreign_key "fabric_stock_exits", "fabric_stocks", column: "estoque_tecido_id"
  add_foreign_key "fabric_stock_exits", "garment_types", column: "tipo_peca_id"
  add_foreign_key "fabric_stocks", "colors", column: "cor_id"
  add_foreign_key "fabric_stocks", "fabric_types", column: "tipo_tecido_id"
  add_foreign_key "financial_fabric_cuts", "fabric_cuts", column: "tecido_corte_id"
  add_foreign_key "financial_fabric_cuts", "financial_records", column: "registro_financeiro_id"
  add_foreign_key "financial_fabric_entries", "fabric_entries", column: "entrada_tecido_id"
  add_foreign_key "financial_fabric_entries", "financial_records", column: "registro_financeiro_id"
  add_foreign_key "financial_garment_finishings", "financial_records", column: "registro_financeiro_id"
  add_foreign_key "financial_garment_finishings", "garment_finishings", column: "peca_acabamento_id"
  add_foreign_key "financial_garment_return_sales", "financial_records", column: "registro_financeiro_id"
  add_foreign_key "financial_garment_return_sales", "garment_sale_returns", column: "peca_venda_retorno_id"
  add_foreign_key "financial_garment_sewings", "financial_records", column: "registro_financeiro_id"
  add_foreign_key "financial_garment_sewings", "garment_sewings", column: "peca_costura_id"
  add_foreign_key "financial_screens_printings", "financial_records", column: "registro_financeiro_id"
  add_foreign_key "financial_screens_printings", "garment_screen_printings", column: "peca_serigrafia_id"
  add_foreign_key "garment_finished_stocks", "garment_types", column: "tipo_peca_id"
  add_foreign_key "garment_finishing_garments", "garment_finished_stocks", column: "estoque_pecas_acabada_id"
  add_foreign_key "garment_finishing_garments", "garment_finishing_stock_exits", column: "saida_peca_estoque_id"
  add_foreign_key "garment_finishing_sizes", "garment_finishing_garments", column: "peca_acabamento_peca_id"
  add_foreign_key "garment_finishing_sizes", "garment_sizes", column: "tamanho_id"
  add_foreign_key "garment_finishing_stock_exits", "garment_finishings", column: "peca_acabamento_id"
  add_foreign_key "garment_finishing_stock_exits", "garment_stocks", column: "estoque_peca_id"
  add_foreign_key "garment_finishings", "entities", column: "acabamento_id"
  add_foreign_key "garment_sale_exits", "entities", column: "vendedor_id"
  add_foreign_key "garment_sale_returns", "entities", column: "vendedor_id"
  add_foreign_key "garment_sale_stock_exits", "garment_finished_stocks", column: "estoque_pecas_acabadas_id"
  add_foreign_key "garment_sale_stock_exits", "garment_sale_exits", column: "peca_venda_saida_id"
  add_foreign_key "garment_screen_garment_sizes", "garment_screen_garments", column: "peca_serigrafia_peca_id"
  add_foreign_key "garment_screen_garment_sizes", "garment_sizes", column: "tamanho_id"
  add_foreign_key "garment_screen_garments", "garment_screen_printing_stock_exits", column: "saida_peca_serigrafia_id"
  add_foreign_key "garment_screen_garments", "garment_stocks", column: "estoque_pecas_id"
  add_foreign_key "garment_screen_printing_stock_exits", "garment_screen_printings", column: "peca_serigrafia_id"
  add_foreign_key "garment_screen_printing_stock_exits", "garment_stocks", column: "estoque_peca_id"
  add_foreign_key "garment_screen_printings", "entities", column: "serigrafia_id"
  add_foreign_key "garment_sewing_garment_sizes", "garment_sewing_garments", column: "peca_costura_peca_id"
  add_foreign_key "garment_sewing_garment_sizes", "garment_sizes", column: "tamanho_id"
  add_foreign_key "garment_sewing_garments", "garment_sewing_stock_exits", column: "saida_peca_estoque_costura_id"
  add_foreign_key "garment_sewing_garments", "garment_stocks", column: "estoque_pecas_id"
  add_foreign_key "garment_sewing_stock_exits", "garment_sewings", column: "peca_costura_id"
  add_foreign_key "garment_sewing_stock_exits", "garment_stocks", column: "estoque_peca_id"
  add_foreign_key "garment_sewings", "entities", column: "costureira_id"
  add_foreign_key "garment_stock_entries", "garment_finished_stocks", column: "saida_peca_acabada_id"
  add_foreign_key "garment_stock_entries", "garment_sale_returns", column: "peca_venda_retorno_id"
  add_foreign_key "garment_stocks", "garment_types", column: "tipo_peca_id"
  add_foreign_key "user_permissions", "users"
end
