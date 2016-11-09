class Pilot < ApplicationRecord
  def self.find_and_update(character_id:, credentials:)
    pilot = where(character_id: character_id).first_or_create
    pilot.update(token: credentials.token,
         refresh_token: credentials.refresh_token)
    pilot
  end

  has_many :tabs
  belongs_to :solar_system, optional: true

  def get_location
    update(solar_system_id: api_character.location_id)
  end

  def is_member_of_alliance?
    corp_id = api_character.corporation_id
    alliance_corp_ids = ::ESI::Alliance.new.member_corp_ids
    alliance_corp_ids.include? corp_id
  end

  def name
    saved_name = read_attribute(:name)
    if saved_name.nil?
      crest_name = api_character.name
      update(name: crest_name)
      saved_name = crest_name
    end
    saved_name
  end

  def root_system
    tabs.detect { |t| t.active? }&.solar_system
  end

  def solar_system_name
    solar_system.name
  end

  def solar_system_k_or_j
    solar_system.k_or_j
  end

  def set_destination(solar_system_id)
    crest_character.set_destination(solar_system_id)
  end

  private

  def crest_character
    @crest ||= ::Crest::Character.new(self)
  end

  def api_character
    @api ||= ::ESI::Character.new(self)
  end
end
