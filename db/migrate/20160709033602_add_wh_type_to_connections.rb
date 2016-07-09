class AddWhTypeToConnections < ActiveRecord::Migration[5.0]
  def change
    add_column :connections, :wh_type, :string
  end
end
