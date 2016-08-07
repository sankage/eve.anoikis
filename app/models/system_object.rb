class SystemObject
  attr_reader :system
  def initialize(solar_system, current_user)
    @system = solar_system
    @current_user = current_user
  end

  def name
    @system.name
  end

  def system_id
    @system.id
  end

  def connection_map
    (@current_user.root_system || @system).connection_map
  end

  def effect
    @system.effect || "no system effect"
  end

  def signatures
    @signatures ||= @system.signatures.includes(:connection).order(:sig_id)
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
end
