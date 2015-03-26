class CreateFormSenderCaches < ActiveRecord::Migration
  def change
    create_table :form_sender_caches do |t|
      t.string :address
      t.timestamp :expires

      t.timestamps
    end
  end
end
