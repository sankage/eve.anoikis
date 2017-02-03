class MemberCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Pilot.where.not(token: nil).where(member: true).find_each do |pilot|
      unless pilot.is_member_of_alliance?
        pilot.update(member: false)
        ActionCable.server.remote_connections.where(current_user: pilot).disconnect
      end
    end
    self.class.set(wait: 60.minutes).perform_later
  end
end
