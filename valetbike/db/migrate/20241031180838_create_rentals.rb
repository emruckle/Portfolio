class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.integer :identifier
      t.references :user, null: false, foreign_key: true
      t.references :bike, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :over_time

      t.timestamps
    end
  end
end
