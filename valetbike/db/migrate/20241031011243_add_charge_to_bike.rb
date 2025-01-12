class AddChargeToBike < ActiveRecord::Migration[7.0]
  def change
    add_column :bikes, :charge, :integer
  end
end
