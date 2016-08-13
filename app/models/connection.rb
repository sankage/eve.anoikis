class Connection < ApplicationRecord
  belongs_to :signature, optional: true
  belongs_to :matched_signature, class_name: "Signature", optional: true
  belongs_to :connection_status

  after_destroy :destroy_inverse, if: :has_inverse?

  def destroy_inverse
    sig = inverse.signature
    inverse.destroy
    sig.destroy
  end

  def has_inverse?
    self.class.exists?(inverse_match_options)
  end

  def inverse
    self.class.find_by(inverse_match_options)
  end

  def inverse_match_options
    { matched_signature_id: signature_id,
      connection_status_id: connection_status_id,
              signature_id: matched_signature_id }
  end

  def create_inverse
    self.class.create(inverse_match_options)
  end

  def update_wh_type(connection_params)
    return if connection_params.nil?
    update(connection_params)
    if inverse
      if connection_params[:wh_type] != "K162"
        inverse.update(wh_type: "K162")
      else
        inverse.update(wh_type: nil)
      end
    end
  end

  def create_connection_status
    return unless connection_status.nil?
    cs = ConnectionStatus.create
    update(connection_status: cs)
  end

  def create_matched_signature(desto_name, source_name)
    return unless matched_signature.nil?
    desto_system = SolarSystem.find_by(name: desto_name)
    return if desto_system.nil?
    sig = Signature.create(solar_system_id: desto_system.id,
                                      type: :cosmic_signature,
                                     group: :wormhole,
                                      name: source_name)
    update(matched_signature_id: sig.id)
    create_inverse
  end
end
