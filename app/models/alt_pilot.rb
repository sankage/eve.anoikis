class AltPilot < ApplicationRecord
  belongs_to :pilot
  belongs_to :alt_pilot, class_name: "Pilot"
end
