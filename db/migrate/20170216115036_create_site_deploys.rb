class CreateSiteDeploys < ActiveRecord::Migration[5.0]
  def change
    create_table :site_deploys do |t|
      t.references :site, foreign_key: true
      t.datetime :started_at
      t.datetime :finished_at
      t.string :status
      t.text :log

      t.timestamps
    end
  end
end
