class RenameSetupLogs < ActiveRecord::Migration[5.0]
  def change
    rename_table :server_setup_logs, :server_setups
    rename_table :site_setup_logs, :site_setups

    rename_column :server_setups, :output, :log
    rename_column :site_setups, :output, :log
  end
end
