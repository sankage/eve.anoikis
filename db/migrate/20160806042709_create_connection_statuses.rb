class CreateConnectionStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :connection_statuses do |t|
      t.integer :mass, default: 0
      t.integer :life, default: 0

      t.timestamps
    end
  end
end
