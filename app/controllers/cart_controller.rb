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
        Ticket.create({
          game: Game.find(gid),
          user: current_user
        })
      end
      redirect_to my_account_index_path, notice: "Successfully purchased #{session[:cart].count} #{'ticket'.pluralize(session[:cart].count)}!"
      session[:cart] = []
    end

    private
  
    def load_cart
      @cartitems = Game.find(session[:cart]).sort
      @cart = session[:cart]
      @subtotal = 0
      @tax = 0
      @creditCardFee = 0
      @total = 0
    end

  end