class AddSecurityToSolarSystems < ActiveRecord::Migration[5.0]
  def change
    add_column :solar_systems, :security, :decimal, precision: 3, scale: 2
  end
end
