class SolarSystemsController < ApplicationController
  before_action :signed_in_user

  def show
    @system = SystemObject.new(params[:id], current_user)
  end
end
