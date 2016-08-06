class Signature < ApplicationRecord
  self.inheritance_column = nil

  def self.create_from_collection(solar_system_id, signatures)
    signatures.each do |sig|
      signature = where(sig_id: sig['sig_id'],
               solar_system_id: solar_system_id).first_or_create do |s|
        s.type = sig['type'].downcase.gsub(' ', '_').to_sym if sig['type']
        s.group = sig['group'].downcase.gsub(' ', '_').to_sym if sig['group']
      end

      updatable_things = {
        group: sig['group']&.downcase.gsub(' ', '_').to_sym
      }

      unless updatable_things[:group] == :wormhole
        updatable_things[:name] = sig["name"]
      end

      signature.update(updatable_things)
      if signature.wormhole? && signature.connection.nil?
        signature.create_connections(signature.solar_system)
      end
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

  def create_connections(solar_system, connection_param = nil)
    if wormhole?
      conn = Connection.where(signature_id: id).first_or_create
      if conn.connection_status.nil?
        cs = ConnectionStatus.create
        conn.update(connection_status: cs)
      end
      conn.update_wh_type(connection_param)
      if conn.matched_signature.nil?
        desto_system = SolarSystem.find_by(name: name)
        return if desto_system.nil?
        sig = Signature.create(solar_system_id: desto_system.id,
                                          type: :cosmic_signature,
                                         group: :wormhole,
                                          name: solar_system.name)
        conn.update(matched_signature_id: sig.id)
        conn.create_inverse
      end
    end
  end

  def connection_status
    connection&.connection_status
  end

  def update_connection_status(params)
    connection_status.update(params)
  end
end
