class CreateGarmentFinishingGarments < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_finishing_garments do |t|
      t.references :estoque_pecas_acabada, null: false, foreign_key: { to_table: :garment_finished_stocks }
      t.references :saida_peca_estoque, null: false, foreign_key: { to_table: :garment_finishing_stock_exits }

      t.timestamps
    end
  end
end
