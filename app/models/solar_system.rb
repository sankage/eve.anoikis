class SolarSystem < ApplicationRecord
  has_many :signatures

  def connection_map
    self.class.connection.select_all(%Q{
      WITH RECURSIVE "map" AS (
        SELECT "id", 0 AS "parent_id", "name", "wormhole_class", "security"
        FROM "solar_systems"
        WHERE "solar_systems"."id" = #{id}
        UNION
        SELECT
          "solar_systems"."id",
          "map"."id" AS "parent_id",
          "solar_systems"."name",
          "solar_systems"."wormhole_class",
          "solar_systems"."security"
        FROM "solar_systems"
        INNER JOIN "signatures" AS "matched_sigs"
                ON "matched_sigs"."solar_system_id" = "solar_systems"."id"
        INNER JOIN "connections"
                ON "connections"."matched_signature_id" = "matched_sigs"."id"
        INNER JOIN "signatures"
                ON "signatures"."id" = "connections"."signature_id"
        INNER JOIN "solar_systems" AS "base_systems"
                ON "base_systems"."id" = "signatures"."solar_system_id"
        INNER JOIN "map"
                ON "map"."id" = "base_systems"."id"
        WHERE "base_systems"."id" = "map"."id"
      )
      SELECT * FROM "map"
    }).to_hash
  end
end
