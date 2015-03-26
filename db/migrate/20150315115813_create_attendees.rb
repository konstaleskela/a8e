class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.references :event, index: true
      t.references :school, index: true

      t.timestamps
    end
  end
end
