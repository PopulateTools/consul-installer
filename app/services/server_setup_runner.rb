require 'fileutils'

class ServerSetupRunner
  attr_reader :server_setup, :server, :inventory_filename

  def initialize(server_setup)
    @server_setup = server_setup
    @server = server_setup.server
    @inventory_filename = "ansible/inventories/inventory_#{server.name}"
  end

  def run

    server_setup.update_attributes!(started_at: Time.current, status: 'started')

    ActionCable.server.broadcast server_setup.cable_log_id, { status: server_setup.status }

    server.update_attributes(status: 'installing')

    write_inventory_file

    command = %Q{
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i #{inventory_filename} ansible/consul_servers.yml --vault-password-file=.vault_password.txt
    }

    return_value, log = CommandRunner.run_command(command, server_setup.cable_log_id)

    status = return_value.success? ? 'ok' : 'error'

    delete_inventory_file

    @server_setup.update_attributes(finished_at: Time.current, status: status, return_value: return_value, log: log)

    server_status = return_value.success? ? 'installed' : 'failed'
    server.update_attributes(status: server_status)

    ActionCable.server.broadcast server_setup.cable_log_id, { status: server_setup.status }

    return return_value, log
  end

  private

  def write_inventory_file
    if server.server_type == 'all'
      file_content = %Q{
[web]
#{server.ip}

[application]
#{server.ip}

[database]
#{server.ip}

[all:children]
web
application
database
      }
    else
      file_content = %Q{
[#{server.server_type}]
#{server.ip}

[all:children]
#{server.server_type}
      }
  end

    File.write inventory_filename, file_content
  end

  def delete_inventory_file
    File.delete inventory_filename
  end
end
