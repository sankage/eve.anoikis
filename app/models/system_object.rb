class SystemObject
  attr_reader :system
  def initialize(solar_system_id, current_user)
    @system = SolarSystem.includes(:notes, :wormhole_types).find_by(id: solar_system_id)
    @current_user = current_user
  end

  def name
    @system.name
  end

  def id
    @system.id
  end

  def connection_map
    (@current_user.root_system || @system).connection_map
  end

  def effect
    {
      name: @system.effect || "no system effect",
      effects: WormholeEffect.new(@system.effect, @system.wormhole_class).effects
    }
  end

  def wormhole?
    @system.wormhole_class <= 6
  end

  def signatures
    @signatures ||= @system.signatures.includes({ connection: :connection_status },
                                                { matched_signature: :solar_system }).order(:sig_id)
  end

  def new_sig
    Signature.new
  end

  def notes
    @system.notes
  end

  def new_note
    Note.new
  end

  def new_tab
    Tab.new
  end

  def statics
    @system.wormhole_types
  end

  def region
    @system.region
  end

  def distances
    return nil if @system.distance_to_jita.nil?
    %w[jita amarr dodixie rens hek stacmon].map { |name|
      [name, @system.distance_to(name)]
    }.to_h
  end
end
