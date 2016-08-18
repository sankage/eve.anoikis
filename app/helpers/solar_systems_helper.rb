module SolarSystemsHelper
  def generate_map(map_data)
    map_data.map { |ss|
      [
        {
          v: "#{ss["id"]}",
          f: <<~NODE
             <div class="node__information node__information--#{system_class(wh_class: ss["wormhole_class"], security: ss["security"]).downcase}"
                  data-node="#{ss["id"]}">
               <h3 class="wh_class">
                 #{system_class(wh_class: ss["wormhole_class"], security: ss["security"])}
                 <span class="sig_id">[#{(ss["sig_id"] || "???").first(3)}]</span>
               </h3>
               <h2>
                 <a href="/systems/#{ss["id"]}">
                   #{ss["name"]}
                 </a>
               </h2>
               <div class="effect">#{ss["effect"]}</div>
               <div class="pilots">#{image_tag("contacts.png")}</div>
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
    when 7
      if security.to_f >= 0.5
        "HS"
      else
        "LS"
      end
    else
      "C#{wh_class}"
    end
  end
end
