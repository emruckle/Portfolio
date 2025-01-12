class AddActiveToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :active, :boolean
  end
end
