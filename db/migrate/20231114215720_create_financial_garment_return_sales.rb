class CreateFinancialGarmentReturnSales < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_garment_return_sales do |t|
      t.references :registro_financeiro, null: false, foreign_key: { to_table: :financial_records }
      t.references :peca_venda_retorno, null: false, foreign_key: { to_table: :garment_sale_returns }

      t.timestamps
    end
  end
end
