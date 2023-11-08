class CreateGarmentFinishingSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_finishing_sizes do |t|
      t.references :peca_acabamento_peca, null: false, foreign_key: { to_table: :garment_finishing_garments }
      t.integer :qtd_tamanho
      t.references :tamanho, null: false, foreign_key: { to_table: :garment_sizes }

      t.timestamps
    end
  end
end
