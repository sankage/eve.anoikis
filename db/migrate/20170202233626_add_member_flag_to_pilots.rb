class AddMemberFlagToPilots < ActiveRecord::Migration[5.0]
  def change
    add_column :pilots, :member, :boolean, default: false
  end
end
