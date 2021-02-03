class TicketsController < ApplicationController
    before_action :set_ticket, only: [:show]

    def show
    end

    private

    def  set_ticket
        @ticket = Ticket.find(params[:id])
    end

end