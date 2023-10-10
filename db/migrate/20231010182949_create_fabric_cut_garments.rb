class CreateFabricCutGarments < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_cut_garments do |t|
      t.references :estoque_pecas, null: false, foreign_key: { to_table: :garment_stocks }
      t.references :saida_tecido_estoque, null: false, foreign_key: { to_table: :fabric_stock_entries }

      t.timestamps
    end
  end
end
