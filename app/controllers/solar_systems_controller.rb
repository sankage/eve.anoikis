class SolarSystemsController < ApplicationController
  def index
  end

  def show
    @system = SolarSystem.find_by(system_id: params[:id])
    @signature = Signature.new
  end
end
