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
  
    private
  
    def load_cart
      @cartitems = Game.find(session[:cart])
    end
  end