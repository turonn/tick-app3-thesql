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
      id = params[:id].to_i
      ticket_count = params[:ticket_count].to_i
      session[:cart].delete(id)
      ticket_count.times {session[:cart] << id}
      redirect_to cart_path
      #respond_to do |format|
      #  format.json { render :index }
      #  format.html { render :index }
      #end
    end

    private
  
    def load_cart
      @cartitems = Game.find(session[:cart]).sort
      @cart = session[:cart]
    end

  end