class MemberCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Pilot.find_each do |pilot|
      if pilot.token && pilot.is_member_of_alliance?
        pilot.update(member: true)
      else
        pilot.update(member: false)
        ActionCable.server.remote_connections.where(current_user: pilot).disconnect
      end
    end
    self.class.set(wait: 60.minutes).perform_later
  end
end
