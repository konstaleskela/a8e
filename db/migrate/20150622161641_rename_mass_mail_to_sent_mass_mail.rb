class RenameMassMailToSentMassMail < ActiveRecord::Migration
  def change
    rename_table :mass_mails, :sent_mass_mails
  end
end
