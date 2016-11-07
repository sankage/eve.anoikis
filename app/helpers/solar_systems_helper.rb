module SolarSystemsHelper
  def generate_map(map_data)
    map_data.map.with_index { |ss, i|
      if ss["id"] == 0
        ss["id"] = "unmapped-#{i}"
      end
      [
        {
          v: "#{ss["id"]}",
          f: <<~NODE
             <div class="node__information node__information--#{system_class(wh_class: ss["wormhole_class"], security: ss["security"]).downcase}"
                  data-node="#{ss["id"]}"
                  data-status="#{status(ss["life"], ss["mass"], ss["frigate_only"])}">
               #{ ss["name"] == "…" ? "" : "<a href='/systems/#{ss["id"]}'>" }
                 <h3 class="wh_class">
                   #{system_class(wh_class: ss["wormhole_class"], security: ss["security"])}
                   <span class="sig_id">[#{(ss["sig_id"] || "???").first(3)}]</span>
                 </h3>
                 <h2>
                   #{ss["name"]}
                 </h2>
                 <div class="effect">#{ss["effect"]}</div>
                 <div class="pilots">#{image_tag("contacts.png")}</div>
               #{ ss["name"] == "…" ? "" : "</a>" }
             </div>
             NODE
        },
        ss["parent_id"] == 0 ? "" : "#{ss["parent_id"]}"
      ]
    }.to_json
  end

  private

  def system_class(wh_class:, security:)
    case wh_class
    when 9 then "NS"
    when 8 then "LS"
    when 7
      if security.to_f >= 0.5
        "HS"
      else
        "LS"
      end
    when nil
      "--"
    else
      "C#{wh_class}"
    end
  end

  def status(life, mass, frigate_only)
    statuses = []
    if life == 1
      statuses << "eol"
    end
    if mass == 1
      statuses << "destab"
    end
    if mass == 2
      statuses << "critical"
    end
    if frigate_only
      statuses << "frig"
    end
    statuses.join(" ")
  end
end
