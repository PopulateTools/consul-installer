class AddRepoUrlToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :repo_url, :string
  end
end
