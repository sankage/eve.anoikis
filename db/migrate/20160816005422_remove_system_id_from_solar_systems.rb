class RemoveSystemIdFromSolarSystems < ActiveRecord::Migration[5.0]
  def up
    remove_column :solar_systems, :system_id
  end

  def down
    add_column :solar_systems, :system_id, :string
  end
end
