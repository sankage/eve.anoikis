class Signature < ApplicationRecord
  self.inheritance_column = nil

  def self.create_from_collection(solar_system, signatures)
    signatures.each do |sig|
      signature = where(sig_id: sig['sig_id'],
               solar_system_id: solar_system.id).first_or_create do |s|
        s.type = sig['type'].downcase.gsub(' ', '_').to_sym if sig['type']
        s.group = sig['group'].downcase.gsub(' ', '_').to_sym if sig['group']
        s.name = sig['name']
      end
      signature.update(name: sig['name'])
    end
  end

  belongs_to :solar_system
  has_one :connection
  has_one :matched_signature, through: :connection

  enum type: [ :cosmic_signature, :cosmic_anomaly ]
  enum group: [ :unknown,
                :wormhole,
                :data_site,
                :relic_site,
                :gas_site,
                :ore_site,
                :combat_site ]
end
