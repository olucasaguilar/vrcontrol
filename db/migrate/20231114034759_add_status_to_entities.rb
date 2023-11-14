class AddStatusToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :status, :integer, default: 1
  end
end