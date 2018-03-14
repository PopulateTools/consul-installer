class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :host
      t.string :base_path
      t.string :db_name
      t.string :db_user
      t.string :db_password
      t.string :rails_env
      t.string :secret_key_base
      t.integer :web_server_id
      t.integer :app_server_id
      t.integer :db_server_id

      t.timestamps
    end

    add_index :sites, :name, unique: true
    add_index :sites, :base_path, unique: true
  end
end
