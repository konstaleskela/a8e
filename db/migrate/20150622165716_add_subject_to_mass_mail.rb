class AddSubjectToMassMail < ActiveRecord::Migration
  def change
    add_column :mass_mails, :subject, :string
  end
end
