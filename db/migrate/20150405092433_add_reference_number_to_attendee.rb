class AddReferenceNumberToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :reference_number, :string
  end
end
