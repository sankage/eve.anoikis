class PilotLocation
  def initialize(pilots = Pilot.order(:name))
    @pilots = pilots
  end

  def groups
    @pilots.each_with_object({}) do |pilot, accum|
      unless pilot.location.system_id.nil?
        key = "#{pilot.location.system_id}|#{pilot.location.name}"
        accum[key] = [] if accum[key].nil?
        accum[key] << pilot.name
      end
    end
  end
end
