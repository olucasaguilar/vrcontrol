class CreateGarmentFinishings < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_finishings do |t|
      t.references :acabamento, null: false, foreign_key: { to_table: :entities }
      t.datetime :data_hora_ida
      t.decimal :total_pecas_envio
      t.decimal :total_pecas_retorno
      t.boolean :finalizado
      t.datetime :data_hora_volta

      t.timestamps
    end
  end
end
