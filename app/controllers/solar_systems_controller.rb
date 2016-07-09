class SolarSystemsController < ApplicationController
  def index
  end

  def show
    solar_system = SolarSystem.find_by(system_id: params[:id])
    @system = SystemObject.new(solar_system)
  end

  def system_names
    systems = SolarSystem.order(:name).pluck(:name)
    wormhole_types = WormholeType.order(:name).pluck(:name)
    render json: { systems: systems, wormhole_types: wormhole_types }
  end
end
