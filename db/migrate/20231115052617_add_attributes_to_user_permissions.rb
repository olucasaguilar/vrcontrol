class AddAttributesToUserPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :user_permissions, :screen_print, :boolean, default: false
    add_column :user_permissions, :screen_print_return, :boolean, default: false

    add_column :user_permissions, :sewing, :boolean, default: false
    add_column :user_permissions, :sewing_return, :boolean, default: false

    add_column :user_permissions, :finishing, :boolean, default: false
    add_column :user_permissions, :finishing_return, :boolean, default: false

    add_column :user_permissions, :sales, :boolean, default: false
    add_column :user_permissions, :sales_return, :boolean, default: false

    add_column :user_permissions, :extras, :boolean, default: false
  end
end
