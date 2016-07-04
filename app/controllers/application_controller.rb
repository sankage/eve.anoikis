class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def signed_in_user
    unless signed_in?
      flash[:alert] = "Please sign in."
      redirect_to root_path
    end
  end
end
