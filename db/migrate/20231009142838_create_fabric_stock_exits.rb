class CreateFabricStockExits < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_stock_exits do |t|
      t.references :tecido_corte, null: false, foreign_key: { to_table: :fabric_cuts }
      t.references :estoque_tecido, null: false, foreign_key: { to_table: :fabric_stocks }
      t.float :multiplicador
      t.float :rendimento
      t.references :tipo_peca, null: false, foreign_key: { to_table: :garment_types }

      t.timestamps
    end
  end
end
