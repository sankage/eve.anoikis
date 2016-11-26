module SessionsHelper
  def sign_in(pilot)
    cookies.signed[:pilot_id] = pilot.id
  end

  def current_user
    @current_user ||= Pilot.includes(:tabs).find_by(id: cookies.signed[:pilot_id])
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:pilot_id)
    @current_user = nil
  end
end
