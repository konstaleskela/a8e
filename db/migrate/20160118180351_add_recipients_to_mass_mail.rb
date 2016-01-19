class AddRecipientsToMassMail < ActiveRecord::Migration
  def change
    add_column :mass_mails, :recipients, :text
  end
end
