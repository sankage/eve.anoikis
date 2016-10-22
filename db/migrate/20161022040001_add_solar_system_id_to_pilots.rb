class AddSolarSystemIdToPilots < ActiveRecord::Migration[5.0]
  def change
    add_reference :pilots, :solar_system, foreign_key: true
  end
end
