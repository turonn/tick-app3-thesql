class MyAccountController < ApplicationController
  before_action :authenticate_user!
  before_action :setFutureUnusedTickets

  def index; end

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
    # @futureUnusedTickets = current_user.tickets.where("game.event_start > ? AND used = ?", (Date.current + 1), false)
    current_user.tickets.each do |ticket|
      if (ticket.game.event_start > (Date.current + 1)) && (ticket.used == false)
        @futureUnusedTickets << ticket 
      end
    end
    @futureUnusedTickets.sort_by! { |ticket| [ticket.game.event_start, ticket.game_id] }
  end

end
