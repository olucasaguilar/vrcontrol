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

ActiveRecord::Schema[7.0].define(version: 2023_10_10_183416) do
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
    t.bigint "saida_tecido_estoque_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "financial_records", force: :cascade do |t|
    t.decimal "valor"
    t.decimal "saldo"
    t.string "tipo_movimento"
    t.string "observacao"
    t.datetime "data_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "garment_sizes", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "entities", "entity_types", column: "entity_types_id"
  add_foreign_key "fabric_cut_garment_sizes", "fabric_cut_garments", column: "tecido_corte_peca_id"
  add_foreign_key "fabric_cut_garment_sizes", "garment_sizes", column: "tamanho_id"
  add_foreign_key "fabric_cut_garments", "fabric_stock_entries", column: "saida_tecido_estoque_id"
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
  add_foreign_key "garment_stocks", "garment_types", column: "tipo_peca_id"
end
