class PilotLocatorJob < ApplicationJob
  queue_as :default

  def perform(pilot)
    pilot.get_location
  end
end
