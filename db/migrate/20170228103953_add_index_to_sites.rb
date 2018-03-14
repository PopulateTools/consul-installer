class AddIndexToSites < ActiveRecord::Migration[5.0]
  def change
    add_index :sites, :db_name, unique: true
  end
end
