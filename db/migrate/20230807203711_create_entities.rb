class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.string :nome
      t.string :num_contato
      t.string :cidade
      t.string :estado
      t.references :entity_types, null: false, foreign_key: true

      t.timestamps
    end
  end
end
