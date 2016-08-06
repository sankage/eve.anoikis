class ConnectionStatus < ApplicationRecord
  def self.human_mass
    masses.keys.map(&:humanize).zip(masses.keys)
  end

  def self.human_life
    lives.keys.map(&:humanize).zip(lives.keys)
  end

  enum life: [:stable, :end_of_life], _suffix: true
  enum mass: [:stable, :destabilized, :verge_of_collapse]

  has_many :connections
end
