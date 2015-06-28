class CreateMassMails < ActiveRecord::Migration
  def change
    create_table :mass_mails do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
  end
end
