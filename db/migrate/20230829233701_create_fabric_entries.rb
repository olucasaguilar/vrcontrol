class CreateFabricEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_entries do |t|
      t.references :entity, null: false, foreign_key: true
      t.datetime :data_hora
      t.decimal :total_tecido

      t.timestamps
    end
  end
end
