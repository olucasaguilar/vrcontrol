class AddTransactionToUserPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_permissions, :transaction, :boolean
    add_column :user_permissions, :transaction_create, :boolean
  end
end
