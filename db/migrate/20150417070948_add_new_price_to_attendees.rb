class AddNewPriceToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :new_price, :integer, :default => false
  end
end
