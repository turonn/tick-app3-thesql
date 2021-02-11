class Ticket < ApplicationRecord
    belongs_to :game
    belongs_to :user

    before_create :ticket_generator

    def ticket_generator
        self.ticket_code = SecureRandom.uuid
        self.used = false
    end
end