class ChangeForeignKeyNameInFabricCutGarments < ActiveRecord::Migration[7.0]
  def change
    remove_reference :fabric_cut_garments, :saida_tecido_estoque, foreign_key: { to_table: :fabric_stock_entries }
  end
end
