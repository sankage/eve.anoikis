class PilotLocation
  def initialize(pilots = Pilot.order(:name).includes(:solar_system))
    @pilots = pilots
    queue_location_jobs
  end

  def groups
    @pilots.each_with_object({}) do |pilot, accum|
      unless pilot.solar_system_id.nil?
        key = "#{pilot.solar_system_id}|#{pilot.solar_system_name}|#{pilot.solar_system_k_or_j}"
        accum[key] = [] if accum[key].nil?
        accum[key] << pilot.name
      end
    end
  end

  private

  def queue_location_jobs
    @pilots.each { |pilot| PilotLocatorJob.perform_later(pilot) }
  end
end
