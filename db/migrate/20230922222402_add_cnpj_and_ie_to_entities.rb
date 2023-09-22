class AddCnpjAndIeToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :cnpj, :string
    add_column :entities, :ie, :string
  end
end
