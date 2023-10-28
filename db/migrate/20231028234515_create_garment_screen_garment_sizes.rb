class CreateGarmentScreenGarmentSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_screen_garment_sizes do |t|
      t.references :peca_serigrafia_peca, null: false, foreign_key: { to_table: :garment_screen_garments }
      t.integer :qtd_tamanho
      t.references :tamanho, null: false, foreign_key: { to_table: :garment_sizes }

      t.timestamps
    end
  end
end
