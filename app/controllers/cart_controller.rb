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
      var = params[:var].to_i
      session[:cart].delete(id)
      var.times {session[:cart] << id}
      redirect_to cart_path
    end

    private
  
    def load_cart
      @cartitems = Game.find(session[:cart])
      @cart = session[:cart]
    end

  end