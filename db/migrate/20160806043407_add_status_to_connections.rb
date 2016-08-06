class AddStatusToConnections < ActiveRecord::Migration[5.0]
  def change
    add_reference :connections, :connection_status, foreign_key: true
  end
end
