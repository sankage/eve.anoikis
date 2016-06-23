module SessionsHelper
  def sign_in(pilot)
    session[:pilot_id] = pilot.id
  end

  def current_user
    @current_user ||= Pilot.find_by(id: session[:pilot_id])
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    session.delete(:pilot_id)
    @current_user = nil
  end
end
