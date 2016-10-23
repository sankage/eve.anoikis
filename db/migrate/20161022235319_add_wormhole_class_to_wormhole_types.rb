class AddWormholeClassToWormholeTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :wormhole_types, :wormhole_class, :integer
  end
end
