class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.belongs_to :game
      t.belongs_to :user
      t.boolean :used
      t.string :ticket_code
    end
  end
end
