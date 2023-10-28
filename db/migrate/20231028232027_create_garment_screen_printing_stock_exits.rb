class CreateGarmentScreenPrintingStockExits < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_screen_printing_stock_exits do |t|
      t.references :peca_serigrafia, null: false, foreign_key: { to_table: :garment_screen_printings }
      t.references :estoque_peca, null: false, foreign_key: { to_table: :garment_stocks }

      t.timestamps
    end
  end
end
