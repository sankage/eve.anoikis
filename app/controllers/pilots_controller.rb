class PilotsController < ApplicationController
  def locations
    render json: PilotLocation.new(Pilot.all).groups
  end
end
