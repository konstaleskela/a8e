class AddExtraInfoToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :dob, :date
    add_column :attendees, :address, :string
    add_column :attendees, :town, :string
    add_column :attendees, :postnumber, :string
    add_column :attendees, :token, :string
  end
end
