class CartController < ApplicationController
    before_action :load_cart
  
    def index
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @cartitems, status: 200}
      end
    end
  
    def show
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @cartitems, status: 200}
      end
    end
  
    def adjust_tickets
      gid = params[:tickets].each do |k, v|
        gid = k.to_i
        ticket_count = v.to_i
        session[:cart].delete(gid)
        ticket_count.times {session[:cart] << gid}
      end
      redirect_to cart_path(2)
      #respond_to do |format|
      #  format.json { render :index }
      #end
    end

    def checkout
      session[:cart].each do |gid|

        game = Game.find(gid)

        if (game.event_start.midnight < Date.current.midnight)
          session[:cart].delete(gid)
          redirect_to cart_index_path notice: 
            "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name} 
            on #{game.event_start.month} #{game.event_start.day} has already happened."
          return
        
        elsif game.tickets.count >= game.max_capacity
          session[:cart].delete(gid)
          redirect_to cart_index_path, notice: 
            "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name} 
            on #{game.event_start.month} #{game.event_start.day} is sold out."
          return

        elsif (game.tickets.count + session[:cart].count(gid)) > game.max_capacity
          session[:cart].delete(gid) 
          remaining_tickets.times(session[:cart] << gid)
          redirect_to cart_index_path, notice: 
            "Could not complete purchase. #{game.gender} #{game.sport} game vs. #{game.visiting_team.name} 
            on #{game.event_start.month} #{game.event_start.day} does not have #{session[:cart].count(gid)} 
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
      session[:cart] = []
      redirect_to my_account_index_path, notice: "Successfully purchased #{session[:cart].count} #{'ticket'.pluralize(session[:cart].count)}!"
    end

    private
  
    def load_cart
      @cartitems = Game.find(session[:cart]).sort_by(&:event_start)
      @cart = session[:cart]
      @subtotal = 0
      @tax = 0
      @creditCardFee = 0
      @total = 0
    end

  end