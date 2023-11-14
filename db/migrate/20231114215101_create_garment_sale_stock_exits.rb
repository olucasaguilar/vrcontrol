class CreateGarmentSaleStockExits < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_sale_stock_exits do |t|
      t.references :peca_venda_saida, null: false, foreign_key: { to_table: :garment_sale_exits }
      t.references :estoque_pecas_acabadas, null: false, foreign_key: { to_table: :garment_finished_stocks }

      t.timestamps
    end
  end
end
