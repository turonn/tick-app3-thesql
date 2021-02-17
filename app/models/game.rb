# == Schema Information
#
# Table name: games
#
#  id               :bigint           not null, primary key
#  event_start      :datetime
#  gender           :string
#  level            :string
#  location         :string
#  max_capacity     :integer
#  price            :integer
#  sport            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  home_team_id     :bigint           not null
#  visiting_team_id :bigint           not null
#
# Indexes
#
#  index_games_on_home_team_id      (home_team_id)
#  index_games_on_visiting_team_id  (visiting_team_id)
#
# Foreign Keys
#
#  fk_rails_...  (home_team_id => schools.id)
#  fk_rails_...  (visiting_team_id => schools.id)
#
class Game < ApplicationRecord
    has_many :tickets
    belongs_to :home_team, class_name: 'School', foreign_key: :home_team_id
    belongs_to :visiting_team, class_name: 'School', foreign_key: :visiting_team_id

    def remaining_tickets
        max_capacity - tickets.count
    end
end
