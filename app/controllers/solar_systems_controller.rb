class SolarSystemsController < ApplicationController
  before_action :signed_in_user

  def show
    @system = SystemObject.new(params[:id], current_user)
  end

  def set_destination
    current_user.set_destination(params[:id])
    redirect_to solar_system_path(params[:id])
  end

  def get_map
    system_object = SystemObject.new(params[:id], current_user)
    json_object = {
      system_map: helpers.generate_map(system_object.connection_map)
    }
    respond_to do |format|
      format.json { render json: json_object }
      format.html { redirect_to system_object.system }
    end
  end
end
