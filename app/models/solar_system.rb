class SolarSystem < ApplicationRecord
  has_many :signatures
  has_many :notes
  has_many :statics
  has_many :wormhole_types, through: :statics

  def connection_map
    self.class.connection.select_all(%Q{
      WITH RECURSIVE map(id, parent_id, name, wormhole_class, security, effect, sig_id, path, cycle) AS (
        SELECT
          "id",
          0,
          "name",
          "wormhole_class",
          "security",
          "effect",
          ''::text,
          ARRAY["id"],
          false
        FROM "solar_systems"
        WHERE "solar_systems"."id" = #{id}
        UNION ALL
        SELECT
          "solar_systems"."id",
          "map"."id" AS "parent_id",
          "solar_systems"."name",
          "solar_systems"."wormhole_class",
          "solar_systems"."security",
          "solar_systems"."effect",
          "signatures"."sig_id",
          path || "solar_systems"."id",
          "solar_systems"."id" = ANY(path)
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
          AND NOT cycle
      )
      SELECT * FROM "map" WHERE NOT cycle ORDER BY sig_id
    }).to_hash
  end
end
