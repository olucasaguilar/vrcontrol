class CreateGarmentStockEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_stock_entries do |t|
      t.references :saida_peca_acabada, null: false, foreign_key: { to_table: :garment_finished_stocks }
      t.references :peca_venda_retorno, null: false, foreign_key: { to_table: :garment_sale_returns }

      t.timestamps
    end
  end
end
