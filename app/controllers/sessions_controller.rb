class SessionsController < ApplicationController
  def new
    redirect_to '/auth/crest'
  end

  def create
    auth = request.env['omniauth.auth']
    pilot = Pilot.find_and_update(character_id: auth['uid'],
                                   credentials: auth['credentials'])
    if pilot&.is_member_of_alliance?
      pilot.update(member: true)
      sign_in pilot
    else
      flash[:alert] = "You are not authorized to be here."
    end

    redirect_to root_path
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_path
  end
end
