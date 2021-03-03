module Events
  class StripeHandler
    def self.process(event)
      stripe_event = Stripe::Event.construct_from(event.data)

      case stripe_event.type
      when 'checkout.session.completed'
        puts stripe_event.customer
        puts "checkout session one"
        sleep(3)
        puts "checkout.session 2"
        sleep(3)
        puts "checkout.session 3"
        sleep(3)
        puts "checkout.session 4"


      when 'payment_intent.succeeded'
        puts stripe_event.customer.email
        puts "Payment Intent 1"
        sleep(3)
        puts "payment_intent 2"
        sleep(3)
        puts "payment_intent 3"
        sleep(3)
        puts "payment_intent 4"

        #tie stripe customer to a devise user
        #unload the game ids and quantity from line items
        #Create the correct number of tickets
          #tied to the correct game id
          #tied to the correct user
      end
    end
  end
end