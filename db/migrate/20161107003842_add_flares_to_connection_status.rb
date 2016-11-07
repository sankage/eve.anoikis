class AddFlaresToConnectionStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :connection_statuses, :flare, :integer, default: 0
  end
end
