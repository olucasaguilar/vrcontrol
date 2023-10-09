class CreateFabricCuts < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_cuts do |t|
      t.datetime :data_hora_ida
      t.decimal :total_tecido_envio
      t.decimal :total_peca_retorno
      t.boolean :finalizado
      t.datetime :data_hora_volta
      t.references :cortador, null: false, foreign_key: { to_table: :entities }

      t.timestamps
    end
  end
end
