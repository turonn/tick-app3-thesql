class CartController < ApplicationController
  before_action :load_cart

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @cartitems, status: 200 }
    end
  end

  def cancel; end

  def success; end

  def adjust_tickets
    params[:tickets].each do |k, v|
      gid = k.to_i
      ticket_count = v.to_i
      session[:cart]["#{gid}"] = ticket_count
    end
    redirect_to cart_index_path
  end
  
  def remove_from_cart
    gid = params[:id].to_i
    session[:cart].delete("#{gid}")
    redirect_to cart_index_path
  end

  def checkout
    
  end

  def create_payment_intent
    payment_intent = Stripe::PaymentIntent.create(
      amount: 1400,
      currency: 'usd'
    )
    render json: {
      clientSecret: payment_intent['client_secret']
    }
  end

  def send_to_stripe
    session[:cart].each do |gid, tik|
      game = Game.find(gid)

      if game.event_start.midnight < Date.current.midnight
        session[:cart].delete("#{gid}")
        redirect_to cart_index_path notice:
          "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name}
            on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day} has already happened."
        return

      elsif game.tickets.count >= game.max_capacity
        session[:cart].delete("#{gid}")
        redirect_to cart_index_path, notice:
          "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name}
            on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day} is sold out."
        return

      elsif (game.tickets.count + tik) > game.max_capacity
        session[:cart]["#{gid}"] = remaining_tickets
        redirect_to cart_index_path, notice:
          "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name}
            on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day} does not have #{tik}
            #{'ticket'.pluralize(tik)} left."
        return
      end
    end
    ticknum = 0
    session[:cart].each do |gid, tik|
      ticknum += tik
      tik.times do
        Ticket.create({
                        game: Game.find(gid),
                        user: current_user
                      })
      end
    end
    session[:cart] = {}
    redirect_to cart_success_path,
                notice: "Successfully purchased #{ticknum} #{'ticket'.pluralize(ticknum)}!"
  end

  private

  def load_cart
    @stripePublicKey = Rails.application.credentials.stripe[:public_key]

    @cartitems = session[:cart].map do | gid, tik |
      [Game.find(gid), tik]
    end
    #@cartitems.sort_by { |game, tik | game.event_start }

    @cart = session[:cart]
    @subtotal = 0
    @tax = 0
    @creditCardFee = 0
    @total = 0
  end
end
