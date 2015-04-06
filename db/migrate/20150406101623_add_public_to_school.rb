class AddPublicToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :public, :boolean, :default => false
  end
end
