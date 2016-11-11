class AddEolStartToConnectionStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :connection_statuses, :eol_start, :datetime
  end
end
