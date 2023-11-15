class AddFabricEntryToUserPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_permissions, :fabric_entry, :boolean, default: false
  end
end
