class AddCapacityToStation < ActiveRecord::Migration[7.0]
  def change
    add_column :stations, :capacity, :integer
  end
end
