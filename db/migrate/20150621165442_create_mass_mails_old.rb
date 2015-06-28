class CreateMassMailsOld < ActiveRecord::Migration
  def change
    create_table :mass_mails do |t|
      t.string :mail_name
      t.references :attendee, index: true

      t.timestamps
    end
  end
end
