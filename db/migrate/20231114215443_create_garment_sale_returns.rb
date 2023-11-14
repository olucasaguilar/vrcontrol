class CreateGarmentSaleReturns < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_sale_returns do |t|
      t.references :vendedor, null: false, foreign_key: { to_table: :entities }
      t.datetime :data_hora

      t.timestamps
    end
  end
end
