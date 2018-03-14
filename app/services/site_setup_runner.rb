require 'fileutils'

class SiteSetupRunner
  attr_reader :site_setup, :site, :inventory_filename, :vars_filename, :full_vars_filename

  def initialize(site_setup)
    @site_setup = site_setup
    @site = site_setup.site
    @inventory_filename = "ansible/inventories/inventory_site_#{site.base_path}"
    @vars_filename = "vars/consul_site_vars_#{site.base_path}.yml"
    @full_vars_filename = "ansible/#{vars_filename}"
  end

  def run
    site_setup.update_attributes!(started_at: Time.current, status: 'started')

    ActionCable.server.broadcast site_setup.cable_log_id, { status: site_setup.status }

    write_inventory_file
    write_vars_file

    command = %Q{
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i #{inventory_filename} ansible/consul_site.yml -e "site_vars_file=#{vars_filename}" --vault-password-file=.vault_password.txt
    }

    return_value, log = CommandRunner.run_command(command, site_setup.cable_log_id)

    status = return_value.success? ? 'ok' : 'error'

    delete_inventory_file
    delete_vars_file

    site_setup.update_attributes(finished_at: Time.current, status: status, return_value: return_value, log: log)

    ActionCable.server.broadcast site_setup.cable_log_id, { status: site_setup.status }

    return return_value, log
  end

  private

  def write_vars_file
    file_content = %Q{
site_name: #{site.name}
site_repo_url: #{site.repo_url}
site_host: #{site.host}
site_base_path: #{site.base_path}
site_db_host: "#{site.db_host}"
site_db_name: #{site.db_name}
site_db_username: #{site.db_user}
site_db_password: #{site.db_password}
site_user: consul
site_group: consul
site_unicorn_host: "#{site.unicorn_host}"
site_unicorn_port: #{site.unicorn_port}
rails_env: #{site.rails_env}
secret_key_base: #{site.secret_key_base}
site_httpauth: #{site.httpauth_protected? ? 'True' : 'False'}
site_census_api_token_host: #{site.census_api_token_host}
site_census_api_username: #{site.census_api_username}
site_census_api_password: #{site.census_api_password}
site_census_api_endpoint: #{site.census_api_endpoint}
    }

    File.write full_vars_filename, file_content
  end

  def delete_vars_file
    File.delete full_vars_filename
  end

  def write_inventory_file
    file_content = %Q{
[web]
#{site.web_server.ip}

[application]
#{site.app_server.ip}

[database]
#{site.db_server.ip}

[all:children]
web
application
database
      }

    File.write inventory_filename, file_content
  end

  def delete_inventory_file
    File.delete inventory_filename
  end
end
