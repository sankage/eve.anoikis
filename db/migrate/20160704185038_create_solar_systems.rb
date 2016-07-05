class CreateSolarSystems < ActiveRecord::Migration[5.0]
  def change
    create_table :solar_systems do |t|
      t.integer :system_id
      t.string :name

      t.timestamps
    end
  end
end
