class AddDefaultToUsersHours < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :hours, from: nil, to: 0.0
  end
end
