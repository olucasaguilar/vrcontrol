class CreateFinancialGarmentFinishings < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_garment_finishings do |t|
      t.references :registro_financeiro, null: false, foreign_key: { to_table: :financial_records }
      t.references :peca_acabamento, null: false, foreign_key: { to_table: :garment_finishings }
      t.boolean :retorno

      t.timestamps
    end
  end
end
