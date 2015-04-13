class AddLateMailsSentToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :late_mails_sent, :integer
  end
end
