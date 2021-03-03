class WebhooksController < ApplicationController
  # disables csrf tokens
  skip_before_action :verify_authenticity_token

  def create
    unless valid_signatures?
      render json: { message: "Invalid signatures" }, status: 400
      return
    end

    unless WebhookEvent.find_by(source: params[:source], external_id: external_id).nil?
      render json: { message: "Already processed #{ external_id }" }
      return
    end

    event = WebhookEvent.create(webhook_params)
    
    ProcessEventsJob.perform_later(event.id)
    render json: params
  end

  def valid_signatures?
    if params[:source] == 'stripe'
      begin
        wh_secret = Rails.application.credentials.stripe[:wh_secret]
        Stripe::Webhook.construct_event(
          request.body.read,
          request.env['HTTP_STRIPE_SIGNATURE'],
          wh_secret
        )
      rescue Stripe::SignatureVerificationError => exception
        return false
      end
    else
      #don't let things talk to webhooks that are not going to webhooks/stripe
      return false
    end
    true
  end

  def external_id
    if params[:source] == 'stripe'
      return params[:id] 
    else
      return 1
    end
  end

  def webhook_params
    {
      source: params[:source],
      data: params.except(:source, :action, :controller).permit!,
      external_id: external_id
    }
  end

  # def create
  #   payload = request.body.read
  #   sig_header = request.env['HTTP_STRIPE_SIGNATURE']
  #   # endpoint_secret = Rails.application.credentials.stripe[:secret_key]
  #   event = nil

  #   begin
  #     event = Stripe::Webhook.construct_event(
  #       payload, sig_header#, endpoint_secret
  #     )
  #   rescue JSON::ParserError => exception
  #     # Invalid payload
  #     render json: { message: exception }, status: 400
  #     return
  #   rescue Stripe::SignatureVerificationError => exception
  #     # Invalid signature
  #     render json: { message: exception }, status: 400
  #     return
  #   end

  #   case event.type
  #   when 'payment_intent.succeeded'
  #     payment_intent = event.data.object #contains a Stripe::PaymentIntent
  #     puts 'PaymentIntent was successful!'
  #   when 'payment_method.attached'
  #   else
  #     puts "unhandled event type: #{event.type}"
  #   end

  #   render json: { message: 'success' }

  # end
end