class PilotLocation
  def initialize(pilots)
    @pilots = pilots
  end

  def groups
    @pilots.each_with_object({}) do |pilot, accum|
      unless pilot.location.system_id.nil?
        accum[pilot.location.name] = [] if accum[pilot.location.name].nil?
        accum[pilot.location.name] << pilot.name
      end
    end
  end
end
