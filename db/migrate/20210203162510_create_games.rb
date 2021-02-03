class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
    t.string :sport
    t.string :gender
    t.string :level
    t.belongs_to :home_team, null: false, foreign_key: { to_table: :schools }
    t.belongs_to :visiting_team, null: false, foreign_key: { to_table: :schools }
    t.string :location
    t.integer :max_capacity
    t.datetime :event_start
    t.integer :price
    end
  end
end
