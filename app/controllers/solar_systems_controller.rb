class SolarSystemsController < ApplicationController
  # before_action :signed_in_user

  def show
    solar_system = SolarSystem.find_by(id: params[:id])
    @system = SystemObject.new(solar_system)
  end

  def system_names
    systems = SolarSystem.order(:name).pluck(:name)
    wormhole_types = WormholeType.order(:name).pluck(:name)
    render json: { systems: systems, wormhole_types: wormhole_types }
  end
end
