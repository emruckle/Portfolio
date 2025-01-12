class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :identifier
      t.string :username
      t.string :first
      t.string :last
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
