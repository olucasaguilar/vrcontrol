class CreateGarmentFinishedStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_finished_stocks do |t|
      t.references :tipo_peca, null: false, foreign_key: { to_table: :garment_types }
      t.integer :quantidade
      t.string :tipo_movimento
      t.datetime :data_hora
      t.integer :saldo

      t.timestamps
    end
  end
end
