class AddFinancialToUserPermissions < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_permissions, :transaction, :boolean
    remove_column :user_permissions, :transaction_create, :boolean
    add_column :user_permissions, :financial, :boolean, default: false
    add_column :user_permissions, :financial_create, :boolean, default: false
  end
end
