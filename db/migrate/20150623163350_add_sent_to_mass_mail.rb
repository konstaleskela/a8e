class AddSentToMassMail < ActiveRecord::Migration
  def change
    add_column :mass_mails, :sent, :boolean
  end
end
