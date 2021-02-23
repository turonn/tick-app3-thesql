class WebhooksController < ApplicationController
  # disables csrf tokens
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.stripe[:secret_key]
    event = nil

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
    when 'payment_intent.succeeded'
      payment_intent = event.data.object #contains a Stripe::PaymentIntent
      puts 'PaymentIntent was successful!'
    when 'payment_method.attached'
    else
      puts "unhandled event type: #{event.type}"
    end

    render json: { message: 'success' }

  end
end