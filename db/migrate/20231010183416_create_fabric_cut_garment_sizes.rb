class CreateFabricCutGarmentSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_cut_garment_sizes do |t|
      t.references :tecido_corte_peca, null: false, foreign_key: { to_table: :fabric_cut_garments }
      t.integer :qtd_tamanho
      t.references :tamanho, null: false, foreign_key: { to_table: :garment_sizes }

      t.timestamps
    end
  end
end
