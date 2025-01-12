class AddDurationToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :duration, :integer
  end
end
