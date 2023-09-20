class CreateFabricStockEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_stock_entries do |t|
      t.references :entrada_tecido, null: false, foreign_key: { to_table: :fabric_entries }
      t.references :estoque_tecido, null: false, foreign_key: { to_table: :fabric_stocks }
      t.decimal :valor_tecido

      t.timestamps
    end
  end
end
