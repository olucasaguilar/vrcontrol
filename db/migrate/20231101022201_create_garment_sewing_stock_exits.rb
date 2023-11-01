class CreateGarmentSewingStockExits < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_sewing_stock_exits do |t|
      t.references :peca_costura, null: false, foreign_key: { to_table: :garment_sewings }
      t.references :estoque_peca, null: false, foreign_key: { to_table: :garment_stocks }

      t.timestamps
    end
  end
end
