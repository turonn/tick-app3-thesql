class MyAccountController < ApplicationController
    before_action :authenticate_user!

    def index
        @futureUnusedTickets = []
        current_user.tickets.each do |ticket|
            if (ticket.game.event_start > (Date.current + 1)) && (ticket.used == false)
                @futureUnusedTickets << ticket
            end
        end
    end

    def tickets
    end
    
    def show
    end
end