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

ActiveRecord::Schema[7.0].define(version: 2023_08_29_233701) do
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
    t.index ["entity_types_id"], name: "index_entities_on_entity_types_id"
  end

  create_table "entity_types", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fabric_entries", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.datetime "data_hora"
    t.decimal "total_tecido"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_fabric_entries_on_entity_id"
  end

  create_table "fabric_types", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "garment_types", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "entities", "entity_types", column: "entity_types_id"
  add_foreign_key "fabric_entries", "entities"
end
