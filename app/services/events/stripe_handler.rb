module Events
  class StripeHandler
    def self.process(event)
      stripe_event = Stripe::Event.construct_from(event.data)

      case stripe_event.type
      when 'checkout.session.completed'
        puts stripe_event.email
        puts 'checkout session one'

      when 'payment_intent.succeeded'
        puts stripe_event.email
        puts 'Payment Intent one'
      end
    end
  end
end