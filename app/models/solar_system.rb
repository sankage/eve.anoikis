class SolarSystem < ApplicationRecord
  has_many :signatures

  def to_param
    system_id.to_s
  end
end
