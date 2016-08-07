class Note < ApplicationRecord
  belongs_to :solar_system
  belongs_to :pilot
end
