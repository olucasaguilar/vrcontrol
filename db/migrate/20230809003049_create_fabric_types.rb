class CreateFabricTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :fabric_types do |t|
      t.string :nome

      t.timestamps
    end
  end
end
