class Connection < ApplicationRecord
  belongs_to :signature, optional: true
  belongs_to :matched_signature, class_name: "Signature", optional: true

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
    { matched_signature_id: signature_id, signature_id: matched_signature_id }
  end

  def create_inverse
    self.class.create(inverse_match_options)
  end

  def update_wh_type(connection_param)
    if connection_param
      update(connection_param)
      if connection_param[:wh_type] != "K162"
        inverse.update(wh_type: "K162")
      else
        inverse.update(wh_type: nil)
      end
    end
  end
end
