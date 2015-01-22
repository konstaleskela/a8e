class RemoveHomes < ActiveRecord::Migration
  def up
    drop_table :homes
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
