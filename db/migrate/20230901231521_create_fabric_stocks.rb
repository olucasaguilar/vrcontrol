class CreateFabricStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_stocks do |t|
      t.references :tipo_tecido, null: false, foreign_key: { to_table: :fabric_types }
      t.references :cor, null: false, foreign_key: { to_table: :colors }
      t.decimal :quantidade
      t.string :tipo_movimento
      t.datetime :data_hora
      t.decimal :saldo

      t.timestamps
    end
  end
end
