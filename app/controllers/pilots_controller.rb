class PilotsController < ApplicationController
  before_action :signed_in_user
  before_action :current_user_only

  def show
    @pilot = Pilot.find(params[:id])
  end

  private

  def current_user_only
    unless params[:id].to_i == current_user.id
      redirect_back(fallback_location: root_path)
    end
  end
end
