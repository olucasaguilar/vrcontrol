class DropFinancialGarmentScreens < ActiveRecord::Migration[7.0]
  def change
    drop_table :financial_garment_screens
  end
end
