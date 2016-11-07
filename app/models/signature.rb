class Signature < ApplicationRecord
  self.inheritance_column = nil

  def self.create_from_collection(solar_system_id, signatures)
    signatures.each do |sig|
      signature = where(sig_id: sig['sig_id'],
               solar_system_id: solar_system_id).first_or_create do |s|
        s.type = sig['type'].downcase.gsub(' ', '_').to_sym if sig['type']
        s.group = sig['group'].downcase.gsub(' ', '_').to_sym if sig['group']
      end

      updatable_things = {}

      unless sig["group"].empty?
        updatable_things[:group] = sig["group"]&.downcase.gsub(' ', '_').to_sym
      end

      unless updatable_things[:group] == :wormhole
        updatable_things[:name] = sig["name"] unless sig["name"].empty?
      end

      signature.update(updatable_things)
      if signature.wormhole? && signature.connection.nil?
        signature.create_connections(signature.solar_system)
      end
    end
  end

  def self.cleanup
    where("created_at < ?", 2.days.ago).destroy_all
  end

  belongs_to :solar_system
  has_one :connection, dependent: :destroy
  has_one :matched_signature, through: :connection

  enum type: [ :cosmic_signature, :cosmic_anomaly ]
  enum group: [ :unknown,
                :wormhole,
                :data_site,
                :relic_site,
                :gas_site,
                :ore_site,
                :combat_site ]

  validates :sig_id, format: { with: /\A[A-Z]{3}-[0-9]{3}\z/,
                            message: "ID requires both letters and numbers (ABC-123)" }

  def create_connections(solar_system, connection_params = nil)
    return unless wormhole?
    conn = Connection.where(signature_id: id).first_or_create
    conn.create_connection_status
    conn.update_wh_type(connection_params)
    conn.update_connection(name)
    conn.create_matched_signature(name, solar_system.name)
  end

  def connection_status
    connection&.connection_status
  end

  def update_connection_status(params)
    return if params.nil? || connection_status.nil?
    connection_status.update(params)
  end
end
