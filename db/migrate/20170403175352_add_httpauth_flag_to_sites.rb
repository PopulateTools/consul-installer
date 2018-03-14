class AddHttpauthFlagToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :httpauth_protected, :boolean, default: true
  end
end
