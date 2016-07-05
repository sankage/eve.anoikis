class Connection < ApplicationRecord
  belongs_to :signature, optional: true
  belongs_to :matched_signature, class_name: "Signature", optional: true
end
