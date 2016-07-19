class AddFieldsToSolarSystems < ActiveRecord::Migration[5.0]
  def change
    add_column :solar_systems, :wormhole_class, :integer
    add_column :solar_systems, :region, :string
    add_column :solar_systems, :constellation, :string
    add_column :solar_systems, :effect, :string
  end
end
