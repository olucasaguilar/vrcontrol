class CreateGarmentScreenGarments < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_screen_garments do |t|
      t.references :estoque_pecas, null: false, foreign_key: { to_table: :garment_stocks }
      t.references :saida_peca_serigrafia, null: false, foreign_key: { to_table: :garment_screen_printing_stock_exits }

      t.timestamps
    end
  end
end
