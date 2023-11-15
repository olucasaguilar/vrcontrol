class AddRelatorioToUserPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_permissions, :relatorio, :boolean, default: false
  end
end
