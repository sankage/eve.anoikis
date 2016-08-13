desc "Run the CREST api calls for all pilots' locations"
task pilot_locator: :environment do
  PilotLocationsJob.perform_later
end
