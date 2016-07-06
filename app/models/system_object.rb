class SystemObject
  attr_reader :system
  def initialize(solar_system)
    @system = solar_system
  end

  def name
    @system.name
  end

  def system_id
    @system.system_id
  end

  def signatures
    @signatures ||= @system.signatures.order(:sig_id)
  end

  def new_sig
    Signature.new
  end
end
