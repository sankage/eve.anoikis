class SolarSystemsController < ApplicationController
  before_action :signed_in_user

  def show
    SignatureCleanupJob.perform_later
    @system = SystemObject.new(params[:id], current_user)
  end

  def set_destination
    current_user.set_destination(params[:id])
    redirect_to solar_system_path(params[:id])
  end
end
