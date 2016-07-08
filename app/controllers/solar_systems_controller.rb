class SolarSystemsController < ApplicationController
  def index
  end

  def show
    solar_system = SolarSystem.find_by(system_id: params[:id])
    @system = SystemObject.new(solar_system)
    @systems = SolarSystem.order(:name)
  end
end
