class CreateServers < ActiveRecord::Migration[5.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :ip
      t.string :server_type
      t.string :status, default: 'new'

      t.timestamps
    end

    add_index :servers, :name, unique: true
  end
end
