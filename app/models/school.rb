# == Schema Information
#
# Table name: schools
#
#  id            :bigint           not null, primary key
#  address1      :string
#  address2      :string
#  city          :string
#  logo_location :string
#  mascot        :string
#  name          :string
#  phone         :string
#  state         :string
#  zip           :string
#
class School < ApplicationRecord
    has_many :home_games, class_name: 'Game', foreign_key: :home_team_id
    has_many :away_games, class_name: 'Game', foreign_key: :visiting_team_id
    has_many :users, class_name: 'User', foreign_key: :home_team_id
end
