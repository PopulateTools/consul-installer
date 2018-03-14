class CreateSiteSetupLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :site_setup_logs do |t|
      t.references :site, foreign_key: true
      t.string :status
      t.datetime :started_at
      t.datetime :finished_at
      t.string :return_value
      t.text :output

      t.timestamps
    end
  end
end
