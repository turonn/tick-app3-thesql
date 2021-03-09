class ScannerController < ApplicationController
  def update
    gid = params[:gid].to_i
    ticket_cde = params[:ticket_code]

    game = Game.find(gid)
    ticket = game.tickets.select { |tik| tik.ticket_code == ticket_cde}

    if ticket == []
      #this returns if the ticket code doesn't exist inside this game
      #they clearly bought the ticket, don't accuse forgery
      render json: { message: 'wrong game' }
      return
    else 
      if ticket.as_json[0]['used']
        #returns if ticket is used already
        render json: { message: 'ticket has been used' }
        return
      else
        #returns if ticket exists AND it is not used
        tik = Ticket.find(ticket.as_json[0]['id'])
        tik.update(used: true)
        render json: { message: 'success' }
        return
      end
    end
  end
end