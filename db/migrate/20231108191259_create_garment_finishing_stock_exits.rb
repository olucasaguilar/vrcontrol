class CreateGarmentFinishingStockExits < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_finishing_stock_exits do |t|
      t.references :peca_acabamento, null: false, foreign_key: { to_table: :garment_finishings }
      t.references :estoque_peca, null: false, foreign_key: { to_table: :garment_stocks }

      t.timestamps
    end
  end
end
