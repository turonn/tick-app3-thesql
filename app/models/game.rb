class Game < ApplicationRecord
    has_many :tickets
    belongs_to :home_team, class_name: 'School', foreign_key: :home_team_id
    belongs_to :visiting_team, class_name: 'School', foreign_key: :visiting_team_id
end