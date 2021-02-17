module CartHelper
  def purchaseable_tickets(game)
    game.remaining_tickets >= 15 ? 15 : game.remaining_tickets
  end
end
