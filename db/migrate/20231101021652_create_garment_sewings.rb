class CreateGarmentSewings < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_sewings do |t|
      t.datetime :data_hora_ida
      t.decimal :total_pecas_envio
      t.decimal :total_pecas_retorno
      t.boolean :finalizado
      t.datetime :data_hora_volta
      t.references :costureira, null: false, foreign_key: { to_table: :entities }

      t.timestamps
    end
  end
end
