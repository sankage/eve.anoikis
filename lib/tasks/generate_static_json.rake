desc "Generate a static json file of systems and wormhole types"
task generate_static_json: :environment do
  systems = SolarSystem.order(:name).pluck(:name)
  wormhole_types = WormholeType.order(:name).pluck(:name)

  File.open(Rails.root.join("public", "static.json"), "w") do |f|
    data = {
      systems: systems,
      wormhole_types: wormhole_types,
      relic_sites: [
        "Forgotten Perimeter Coronation Platform",
        "Forgotten Perimeter Power Array",
        "Forgotten Perimeter Gateway",
        "Forgotten Perimeter Habitation Coils",
        "Forgotten Frontier Quarantine Outpost",
        "Forgotten Frontier Recursive Depot",
        "Forgotten Frontier Conversion Module",
        "Forgotten Frontier Evacuation Center",
        "Forgotten Core Data Field",
        "Forgotten Core Information Pen",
        "Forgotten Core Assembly Hall",
        "Forgotten Core Circuitry Disassembler"
      ].sort,
      data_sites: [
        "Unsecured Perimeter Amplifier",
        "Unsecured Perimeter Information Center",
        "Unsecured Perimeter Comms Relay",
        "Unsecured Perimeter Transponder Farm",
        "Unsecured Frontier Database",
        "Unsecured Frontier Receiver",
        "Unsecured Frontier Digital Nexus",
        "Unsecured Frontier Trinary Hub",
        "Unsecured Frontier Enclave Relay",
        "Unsecured Frontier Server Bank",
        "Unsecured Core Backup Array",
        "Unsecured Core Emergence"
      ].sort,
      combat_sites: [
        "Perimeter Ambush Point",
        "Perimeter Camp",
        "Phase Catalyst Node",
        "The Line",
        "Perimeter Checkpoint",
        "Perimeter Hangar",
        "Sleeper Data Signature Sanctuary",
        "The Ruins of Enclave Cohort 27",
        "Fortification Frontier Stronghold",
        "Outpost Frontier Stronghold",
        "Solar Cell",
        "The Oruze Construct",
        "Frontier Barracks",
        "Frontier Command Post",
        "Integrated Terminus",
        "Sleeper Information Sanctum",
        "Core Garrison",
        "Core Stronghold",
        "Oruze Osobnyk",
        "Quarantine Area",
        "Core Bastion",
        "Core Citadel",
        "Strange Energy Readings",
        "The Mirror"
      ].sort,
      gas_sites: [
        "Barren Perimeter Reservoir",
        "Bountiful Frontier Reservoir",
        "Instrumental Core Reservoir",
        "Minor Perimeter Reservoir",
        "Ordinary Perimeter Reservoir",
        "Sizeable Perimeter Reservoir",
        "Token Perimeter Reservoir",
        "Vast Frontier Reservoir",
        "Vital Core Reservoir"
      ].sort
    }.to_json
    f.puts data
  end
end
