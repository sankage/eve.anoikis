desc "Start the various background jobs"
task background_jobs: :environment do
  puts "Background jobs starting"
  PilotLocationsJob.perform_later
  puts ">> Pilot Locations started"
  SignatureCleanupJob.perform_later
  puts ">> Signature Cleanup started"
  MemberCheckJob.perform_later
  puts ">> Member Check started"
  puts "All jobs started"
end
