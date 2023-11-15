class AddCpfToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :cpf, :string
  end
end
