class CreateTabs < ActiveRecord::Migration[5.0]
  def change
    create_table :tabs do |t|
      t.string :name
      t.boolean :active, default: false
      t.belongs_to :solar_system, foreign_key: true
      t.belongs_to :pilot, foreign_key: true

      t.timestamps
    end
  end
end
