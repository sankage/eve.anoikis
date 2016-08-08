class CreateStatics < ActiveRecord::Migration[5.0]
  def change
    create_table :statics do |t|
      t.belongs_to :solar_system, foreign_key: true
      t.belongs_to :wormhole_type, foreign_key: true

      t.timestamps
    end
  end
end
