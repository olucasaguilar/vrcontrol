class AddAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :user_permissions, :fabric_stock, :boolean, default: false
    add_column :user_permissions, :garment_stock, :boolean, default: false
    add_column :user_permissions, :finished_garment_stock, :boolean, default: false
  end
end
