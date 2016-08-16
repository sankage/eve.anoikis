class ChangePrecisionToSolarSystems < ActiveRecord::Migration[5.0]
  def up
    change_column :solar_systems, :security, :decimal, precision: 2, scale: 1
  end

  def down
    change_column :solar_systems, :security, :decimal, precision: 3, scale: 2
  end
end
