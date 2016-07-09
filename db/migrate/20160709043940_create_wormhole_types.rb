class CreateWormholeTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :wormhole_types do |t|
      t.string :name
      t.integer :mass_total, limit: 8
      t.integer :mass_jump
      t.integer :mass_regen
      t.string :leads_to

      t.timestamps
    end
  end
end
