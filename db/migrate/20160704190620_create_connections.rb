class CreateConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
      t.references :signature, foreign_key: true
      t.references :matched_signature, index: true

      t.timestamps
    end

    add_foreign_key :connections, :signatures, column: :matched_signature_id
    add_index :connections, [:signature_id, :matched_signature_id], unique: true
  end
end
