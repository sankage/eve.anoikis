class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.text :text
      t.belongs_to :solar_system, foreign_key: true
      t.belongs_to :pilot, foreign_key: true

      t.timestamps
    end
  end
end
