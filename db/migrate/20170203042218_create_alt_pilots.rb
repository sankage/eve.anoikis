class CreateAltPilots < ActiveRecord::Migration[5.0]
  def change
    create_table :alt_pilots do |t|
      t.belongs_to :pilot, foreign_key: true
      t.belongs_to :alt_pilot, foreign_key: true

      t.timestamps
    end
  end
end
