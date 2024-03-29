class SolarSystem < ApplicationRecord
  has_many :signatures
  has_many :notes
  has_many :statics
  has_many :wormhole_types, through: :statics

  def connection_map
    self.class.connection.select_all(%Q{
      SELECT * FROM (
        WITH RECURSIVE map(id, parent_id, name, wormhole_class, frigate_only, security, effect, sig_id, mass, life, flare, path, cycle) AS (
          SELECT
            "id",
            0,
            "name",
            "wormhole_class",
            false,
            "security"::numeric,
            "effect",
            ''::text,
            0,
            0,
            0,
            ARRAY["id"],
            false
          FROM "solar_systems"
          WHERE "solar_systems"."id" = #{id}
        UNION ALL
          SELECT
            "solar_systems"."id",
            "map"."id" AS "parent_id",
            coalesce("solar_systems"."name", null),
            coalesce("solar_systems"."wormhole_class", null),
            "connection_statuses"."frigate_only",
            coalesce("solar_systems"."security", null::numeric)::numeric(2,1),
            coalesce("solar_systems"."effect", null),
            "signatures"."sig_id",
            coalesce("connection_statuses"."mass", null),
            coalesce("connection_statuses"."life", null),
            "connection_statuses"."flare",
            path || "solar_systems"."id",
            "solar_systems"."id" = ANY(path)
          FROM "signatures" AS "matched_sigs"
          LEFT JOIN "solar_systems"
                 ON "matched_sigs"."solar_system_id" = "solar_systems"."id"
          INNER JOIN "connections"
                  ON "connections"."matched_signature_id" = "matched_sigs"."id"
          INNER JOIN "connection_statuses"
                  ON "connection_statuses"."id" = "connections"."connection_status_id"
          INNER JOIN "signatures"
                  ON "signatures"."id" = "connections"."signature_id"
          INNER JOIN "solar_systems" AS "base_systems"
                  ON "base_systems"."id" = "signatures"."solar_system_id"
          INNER JOIN "map"
                  ON "map"."id" = "base_systems"."id"
          WHERE "base_systems"."id" = "map"."id"
            AND NOT cycle
        )
        SELECT "map".* FROM "map" WHERE NOT "map"."cycle"
        UNION
        SELECT
          0 AS "id",
          "signatures"."solar_system_id",
          '…' AS "name",
          "wormhole_types"."wormhole_class" AS "wormhole_class",
          "connection_statuses"."frigate_only",
          1.0 AS "security",
          null AS "effect",
          "signatures"."sig_id",
          COALESCE("connection_statuses"."mass", 0) AS mass,
          COALESCE("connection_statuses"."life", 0) AS life,
          "connection_statuses"."flare",
          "map"."path",
          false AS "cycle"
        FROM "signatures"
        INNER JOIN "map"
                ON "signatures"."solar_system_id" = "map"."id"
                AND "signatures"."sig_id" != "map"."sig_id"
        LEFT JOIN "connections"
                ON "connections"."signature_id" = "signatures"."id"
        LEFT JOIN "connection_statuses"
                ON "connection_statuses"."id" = "connections"."connection_status_id"
        LEFT JOIN "wormhole_types"
               ON "wormhole_types"."name" = "connections"."wh_type"
        WHERE "signatures"."group" = 1
          AND "signatures"."name" = ''
      ) AS "connection_map" ORDER BY "connection_map"."sig_id"
    }).to_hash
  end

  def distance_to(system_name)
    public_send("distance_to_#{system_name}".to_sym)
  end

  def k_or_j
    if (7..9).include? wormhole_class
      "k"
    else
      "j"
    end
  end
end
