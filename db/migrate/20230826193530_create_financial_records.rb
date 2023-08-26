class CreateFinancialRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_records do |t|
      t.decimal :valor
      t.decimal :saldo
      t.string :tipo_movimento
      t.string :observacao
      t.datetime :data_hora

      t.timestamps
    end
  end
end
