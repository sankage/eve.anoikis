module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      ActiveRecord::Base.connection_pool.with_connection do
        if current_user = Pilot.find_by(id: cookies.signed[:pilot_id])
          current_user
        else
          reject_unauthorized_connection
        end
      end
    end
  end
end
