class AddFabricCutToUserPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_permissions, :fabric_cut, :boolean, default: false
    add_column :user_permissions, :fabric_cut_return, :boolean, default: false
  end
end
