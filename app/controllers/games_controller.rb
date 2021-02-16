class GamesController < ApplicationController
    before_action :set_game, only: [:show, :edit, :update, :destroy]
    before_action :load_cart
    before_action :set_future_games

    def show
    end

    def new
        @game = Game.new
    end

    def edit
    end

    def index
        respond_to do |format|
            format.html { render :index }
            format.json { render json: @games, include: [ :home_team, :visiting_team ], status: 200}
        end
    end

    def create
        @game = Game.new(game_params)

        respond_to do |format|
            if @game.save
                format.html { redirect_to @game, notice: "Game was created successfully!" }
                format.json { render :show, status: :created, location: @game }
            else
                format.html { render :new, notice: "Game failed to create!" }
                format.json { render json: @game.errors, status: :unprocessable_entity}
            end
        end
    end

    def update
        respond_to do |format|
            if @game.update(game_params)
                format.html { redirect_to @game, notice: "Game was updated successfully!" }
                format.json { render :show, status: :created, location: @game }
            else
                format.html { render :edit, notice: "Game failed to update!" }
                format.json { render json: @game.errors, status: :unprocessable_entity}
            end
        end
    end

    def destroy
        respond_to do |format|
            if @game.destroy
                format.html { redirect_to @home, notice: "Game was deleted successfully!" }
                format.json { render :show, status: :created, location: @game }
            else
                format.html { render :edit, notice: "Game failed to delete!" }
                format.json { render json: @game.errors, status: :unprocessable_entity}
            end
        end
    end

    def add_to_cart
        id = params[:id].to_i
        session[:cart] << id
        redirect_to cart_path
    end

    def remove_from_cart
        id = params[:id].to_i
        session[:cart].delete(id)
        redirect_to cart_path
    end

    private

    def load_cart
        @cartitems = Game.find(session[:cart])
    end

    def set_future_games
        @futureGames = []
        @futureGames = Game.where("event_start > ?", (Date.current - 1)).order(:event_start)
         #Need to add autherization to POST...eventually
    end

    def  set_games
        @game = Game.find(params[:id])
    end

    def game_params
        params.require(:game).permit(:sport, :gender, :level, :home_team, :visiting_team, :location, :max_capacity, :event_date, :event_time, :price)
    end

end