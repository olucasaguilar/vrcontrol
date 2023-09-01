class CreateFinancialFabricEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_fabric_entries do |t|
      t.references :registro_financeiro, null: false, foreign_key: { to_table: :financial_records }
      t.references :entrada_tecido, null: false, foreign_key: { to_table: :fabric_entries }

      t.timestamps
    end
  end
end
