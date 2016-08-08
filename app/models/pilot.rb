class Pilot < ApplicationRecord
  def self.find_and_update(character_id:, credentials:)
    pilot = where(character_id: character_id).first_or_create
    pilot.update(token: credentials.token,
         refresh_token: credentials.refresh_token)
    pilot
  end

  has_many :tabs

  def location
    crest_character.location
  end

  def is_member_of_alliance?
    corp = crest_character.corporation
    alliance_corps = ::Crest::Alliance.new.member_corps
    alliance_corps.map(&:id).include? corp.id
  end

  def name
    saved_name = read_attribute(:name)
    if saved_name.nil?
      crest_name = crest_character.name
      write_attribute(:name, crest_name)
      saved_name = crest_name
    end
    saved_name
  end

  def root_system
    tabs.detect { |t| t.active? }&.solar_system
  end

  private

  def crest_character
    @crest ||= ::Crest::Character.new(self)
  end
end
