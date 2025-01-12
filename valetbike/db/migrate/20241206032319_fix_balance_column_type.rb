class FixBalanceColumnType < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :balance, :floatail # Remove the invalid column
    add_column :users, :balance, :float, default: 0.0 # Add the column with the correct type
  end
end
