class AddFrigateOnlyToConnectionStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :connection_statuses, :frigate_only, :boolean, default: false
  end
end
