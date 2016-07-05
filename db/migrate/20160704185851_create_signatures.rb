class CreateSignatures < ActiveRecord::Migration[5.0]
  def change
    create_table :signatures do |t|
      t.references :solar_system, foreign_key: true
      t.string :sig_id
      t.integer :type
      t.integer :group
      t.string :name

      t.timestamps
    end
  end
end
