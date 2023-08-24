class CreateGarmentSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :garment_sizes do |t|
      t.string :nome

      t.timestamps
    end
  end
end
