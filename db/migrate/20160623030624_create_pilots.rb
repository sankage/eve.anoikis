class CreatePilots < ActiveRecord::Migration[5.0]
  def change
    create_table :pilots do |t|
      t.integer :character_id
      t.string :name
      t.string :token
      t.string :refresh_token

      t.timestamps
    end
  end
end
