# == Schema Information
#
# Table name: tickets
#
#  id          :bigint           not null, primary key
#  ticket_code :string
#  used        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_tickets_on_game_id  (game_id)
#  index_tickets_on_user_id  (user_id)
#
class Ticket < ApplicationRecord
    belongs_to :game
    belongs_to :user

    before_create :ticket_generator

    def ticket_generator
        self.ticket_code = SecureRandom.uuid
        self.used = false
    end
end
