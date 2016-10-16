class SignatureCleanupJob < ApplicationJob
  queue_as :low_priority

  def perform(*args)
    Signature.cleanup
  end
end
