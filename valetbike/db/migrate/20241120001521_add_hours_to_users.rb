class AddHoursToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hours, :float
  end
end
