class AddConfirmedToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :confirmed, :boolean, :default => false
  end
end
