class School < ApplicationRecord
    has_many :games
    has_many :users
end