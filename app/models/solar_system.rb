class SolarSystem < ApplicationRecord
  has_many :signatures

  def to_param
    system_id.to_s
  end

  def map
    ss = self.class.connection.select_all(%Q{
      WITH RECURSIVE "map" AS (
        SELECT "id", "system_id", "name", 0 AS "parent_id"
        FROM "solar_systems"
        WHERE "solar_systems"."system_id" = #{system_id}
        UNION
        SELECT "solar_systems"."id", "solar_systems"."system_id", "solar_systems"."name", "map"."id" AS "parent_id"
        FROM "solar_systems"
        INNER JOIN "signatures" AS "matched_signatures" ON "matched_signatures"."solar_system_id" = "solar_systems"."id"
        INNER JOIN "connections" ON "connections"."matched_signature_id" = "matched_signatures"."id"
        INNER JOIN "signatures" ON "signatures"."id" = "connections"."signature_id"
        INNER JOIN "solar_systems" AS "base_systems" ON "base_systems"."id" = "signatures"."solar_system_id"
        INNER JOIN "map" ON "map"."id" = "base_systems"."id"
        WHERE "base_systems"."system_id" = "map"."system_id"
      )
      SELECT * FROM "map"
    }).to_hash
    ss.map do |s|
      [
        { v: "#{s["id"]}", f: "<a href='/systems/#{s["system_id"]}'>#{s["name"]}</a>" },
        s["parent_id"] == 0 ? "" : "#{s["parent_id"]}"
      ]
    end
  end
end
