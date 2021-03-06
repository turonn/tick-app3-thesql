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
    #run private method to check to see if the games are sold out,
    #buying more tickets than availible, or in the past
    check_ticket_availibility

    subTotal = 0

    cartItems = session[:cart].map do |gid, tik|
      game = Game.find(gid)
      subTotal += game.price * tik
      {
        price_data: {
          unit_amount: game.price,
          currency: 'usd',
          product_data: {
            name: "#{game.home_team.name} vs. #{game.visiting_team.name}",
            description: "#{game.gender} #{game.level} #{game.sport} on #{Date::MONTHNAMES[game.event_start.month]} #{game.event_start.day}."               
          }
        },
        quantity: tik
      }
    end
      
    #add credit card fee to the end of cartItems
    cartItems <<  {
        price_data: {
          unit_amount: (subTotal * 0.0298661174 + 30.895983522).round(),
          currency: 'usd',
          product_data: {
            name: "credit card fee"
          }
        },
        quantity: 1
      }
        
    session = Stripe::Checkout::Session.create({
      customer_email: current_user.email,
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

  def create_tickets
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

  def check_ticket_availibility
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
  end
end
