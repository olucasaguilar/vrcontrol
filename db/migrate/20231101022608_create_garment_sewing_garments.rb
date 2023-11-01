class CreateGarmentSewingGarments < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_sewing_garments do |t|
      t.references :estoque_pecas, null: false, foreign_key: { to_table: :garment_stocks }
      t.references :saida_peca_estoque_costura, null: false, foreign_key: { to_table: :garment_sewing_stock_exits }

      t.timestamps
    end
  end
end
