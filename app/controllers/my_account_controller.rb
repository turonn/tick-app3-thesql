class MyAccountController < ApplicationController
    before_action :authenticate_user!
    before_action :setFutureUnusedTickets

    def index
    end

    def tickets
        respond_to do |format|
            format.html { render :tickets }
        end
    end
    
    def show
        respond_to do |format|
            format.html { render :tickets }
        end
    end

    private

    def setFutureUnusedTickets
        @futureUnusedTickets = []
        current_user.tickets.each do |ticket|
            if (ticket.game.event_start > (Date.current + 1)) && (ticket.used == false)
                @futureUnusedTickets << ticket
            end
        end
    end
end