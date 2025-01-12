class ChangeUserForeignKeyInRentals < ActiveRecord::Migration[7.0]
  def change
    change_column_null :rentals, :user_id, true
    remove_foreign_key :rentals, :users
    add_foreign_key :rentals, :users, on_delete: :nullify
  end
end
