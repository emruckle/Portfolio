class AddBalanceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :floatail
    change_column_default :users, :balance, from:nil, to: 0.0
  end
end
