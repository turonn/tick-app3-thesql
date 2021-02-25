class CartController < ApplicationController
  before_action :load_cart

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @cartitems, status: 200 }
    end
  end

  def success; end

  def cancel; end

  def adjust_tickets
    gid = params[:tickets].each do |k, v|
      gid = k.to_i
      ticket_count = v.to_i
      session[:cart].delete(gid)
      ticket_count.times { session[:cart] << gid }
    end
    redirect_to cart_index_path
  end

  def testing
    games = Game.find(session[:cart])

    cartItems = games.map do |game|
      {
        price_data: {
          unit_amount: game.price,
          currency: 'usd',
          product_data: {
            name: "#{game.home_team.name} vs. #{game.visiting_team.name}",
            description: "#{game.gender} #{game.level} #{game.sport} on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day}."               
          }
        },
        quantity: 1
      }
    end

    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: cartItems,
      mode: 'payment',
      success_url: cart_success_url,
      cancel_url: cart_cancel_url
    })

    render json: {
      id: session.id
    }.to_json
  end

  def checkout
    session[:cart].each do |gid|
      game = Game.find(gid)

      if game.event_start.midnight < Date.current.midnight
        session[:cart].delete(gid)
        redirect_to cart_index_path notice:
          "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name}
            on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day} has already happened."
        return

      elsif game.tickets.count >= game.max_capacity
        session[:cart].delete(gid)
        redirect_to cart_index_path, notice:
          "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name}
            on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day} is sold out."
        return

      elsif (game.tickets.count + session[:cart].count(gid)) > game.max_capacity
        session[:cart].delete(gid)
        remaining_tickets.times(session[:cart] << gid)
        redirect_to cart_index_path, notice:
          "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name}
            on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day} does not have #{session[:cart].count(gid)}
            #{'ticket'.pluralize(session[:cart].count(gid))} left."
        return
      end
    end

    session[:cart].each do |gid|
      Ticket.create({
                      game: Game.find(gid),
                      user: current_user
                    })
    end
    ticknum = session[:cart].count
    session[:cart] = []
    redirect_to my_account_index_path,
                notice: "Successfully purchased #{ticknum} #{'ticket'.pluralize(ticknum)}!"
  end

  private

  def load_cart
    @stripePublicKey = Rails.application.credentials.stripe[:public_key]
    @cartitems = Game.find(session[:cart]).sort_by(&:event_start)
    @cart = session[:cart]
    @subtotal = 0
    @tax = 0
    @creditCardFee = 0
    @total = 0
  end
end
