class WebhooksController < ApplicationController
  # disables csrf tokens
  skip_before_action :verify_authenticity_token

  # def create
  #   unless valid_signatures?
  #     render json: { message: "Invalid signatures" }, status: 400
  #     return
  #   end

  #   unless WebhookEvent.find_by(source: params[:source], external_id: external_id).nil?
  #     render json: { message: "Already processed #{ external_id }" }
  #     return
  #   end

  #   event = WebhookEvent.create(webhook_params)

  #   ProcessEventsJob.perform_later(event.id)
  #   render json: params
  # end

  # def valid_signatures?
  #   if params[:source] == 'stripe'
  #     begin
  #       wh_secret = Rails.application.credentials.stripe[:wh_secret]
  #       Stripe::Webhook.construct_event(
  #         request.body.read,
  #         request.env['HTTP_STRIPE_SIGNATURE'],
  #         wh_secret
  #       )
  #     rescue Stripe::SignatureVerificationError => exception
  #       return false
  #     end
  #   else
  #     #don't let things talk to webhooks that are not going to webhooks/stripe
  #     return false
  #   end
  #   true
  # end

  # def external_id
  #   if params[:source] == 'stripe'
  #     return params[:id] 
  #   else
  #     return 1
  #   end
  # end

  # def webhook_params
  #   {
  #     source: params[:source],
  #     data: params.except(:source, :action, :controller).permit!,
  #     external_id: external_id
  #   }
  # end

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe[:wh_secret]
    event = nil

    #need a way to check to see if we ran this request already

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => exception
      # Invalid payload
      render json: { message: exception }, status: 400
      return
    rescue Stripe::SignatureVerificationError => exception
      # Invalid signature
      render json: { message: exception }, status: 400
      return
    end

    case event.type
      when 'checkout.session.completed'
        checkout_session = event.data.object #contains a Stripe::PaymentIntent
        create_tickets(checkout_session.metadata)
      else
        puts "unhandled event type: #{event.type}"
    end

    render json: { message: 'success' }

  end

  private

  def create_tickets(metadata)
    user = User.find(metadata.user_id)

    metadata.as_json.except('user_id').each do |gid, tiks|      
      tik = tiks.to_i
      tik.times do
        Ticket.create({
                        game: Game.find(gid),
                        user: user
                      })
      end
    end
  end

end
