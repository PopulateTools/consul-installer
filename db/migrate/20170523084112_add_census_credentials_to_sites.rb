class AddCensusCredentialsToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :census_api_username, :string
    add_column :sites, :census_api_password, :string
    add_column :sites, :census_api_token_host, :string
    add_column :sites, :census_api_endpoint, :string
  end
end
