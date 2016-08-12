class AddDistancesToSolarSystems < ActiveRecord::Migration[5.0]
  def change
    add_column :solar_systems, :distance_to_jita, :integer
    add_column :solar_systems, :distance_to_amarr, :integer
    add_column :solar_systems, :distance_to_dodixie, :integer
    add_column :solar_systems, :distance_to_rens, :integer
    add_column :solar_systems, :distance_to_hek, :integer
    add_column :solar_systems, :distance_to_stacmon, :integer
  end
end
