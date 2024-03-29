class PilotLocationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    pl = PilotLocation.new
    ActionCable.server.broadcast "pilot_locations", locations: pl.groups
    self.class.set(wait: 5.seconds).perform_later
  end
end
