class CreateUserPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :admin, default: false
      t.boolean :entities, default: false
      t.boolean :entities_create, default: false
      
      t.timestamps
    end
  end
end
