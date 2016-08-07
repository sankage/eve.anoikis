class Tab < ApplicationRecord
  belongs_to :solar_system
  belongs_to :pilot

  default_scope -> { order(:created_at) }
end
