class CreateFinancialFabricCuts < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_fabric_cuts do |t|
      t.references :registro_financeiro, null: false, foreign_key: { to_table: :financial_records }
      t.references :tecido_corte, null: false, foreign_key: { to_table: :fabric_cuts }
      t.boolean :retorno

      t.timestamps
    end
  end
end
