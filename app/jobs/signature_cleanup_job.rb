class SignatureCleanupJob < ApplicationJob
  queue_as :low_priority

  def perform(*args)
    Signature.cleanup
    self.class.set(wait: 60.minutes).perform_later
  end
end
