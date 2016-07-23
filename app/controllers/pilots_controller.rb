class PilotsController < ApplicationController
  before_action :signed_in_user

  def locations
    render json: PilotLocation.new(Pilot.all).groups
  end
end
