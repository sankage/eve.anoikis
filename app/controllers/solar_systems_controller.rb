class SolarSystemsController < ApplicationController
  before_action :signed_in_user

  def show
    SignatureCleanupJob.perform_later
    @system = SystemObject.new(params[:id], current_user)
  end
end
