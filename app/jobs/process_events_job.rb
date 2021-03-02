class ProcessEventsJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    event = WebhookEvent.find(event_id)
    if event.pending? || event.failed?
      event.update(state: :processing)

      begin
        case event.source
        when 'stripe'
          Events::StripeHandler.process(event)
        when 'paypal'
          #Events::PayPalHandler.process(event)
        end
        event.update(state: :processed)
      rescue => exception
        #in case it fails?
        event.update(state: :failed, processing_errors: exception)
      end
    end

  end
end
