class CreateFinancialGarmentScreens < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_garment_screens do |t|
      t.references :registro_financeiro, null: false, foreign_key: { to_table: :financial_records }
      t.references :peca_serigrafia, null: false, foreign_key: { to_table: :garment_screen_printings }
      t.boolean :retorno

      t.timestamps
    end
  end
end
