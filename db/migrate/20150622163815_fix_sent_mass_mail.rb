class FixSentMassMail < ActiveRecord::Migration
  def change
    remove_column :sent_mass_mails, :mail_name, :string
    add_column :sent_mass_mails, :mass_mail_id, :integer
    add_index :sent_mass_mails, :mass_mail_id
  end
end
