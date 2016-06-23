class Pilot < ApplicationRecord
  def self.find_and_update(character_id:, credentials:)
    pilot = find_by(character_id: character_id)
    return nil if pilot.nil?
    pilot.update(token: credentials.token,
         refresh_token: credentials.refresh_token)
    pilot
  end
end
