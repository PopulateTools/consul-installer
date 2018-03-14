require 'fileutils'

class SiteDeployRunner
  def initialize(site_deploy)
    @deploy = site_deploy

    @clone_dir = File.join(Rails.root, "/tmp/site_deploys")

    @run_dir = File.join(Rails.root, "/tmp/site_deploys/#{@deploy.site.base_path}/src")
    FileUtils.mkdir_p @run_dir

    @recipe_dir = File.join(Rails.root, "recipes/consul_site/")

    @template_dir = File.join(Rails.root, "recipes/consul_site/templates/")

    @environment = @deploy.environment
    @application_name = @deploy.site.name
    @repo_url = @deploy.site.repo_url
    @site_deploy_path = File.join("/var/www", @deploy.site.base_path)
    @ssh_key_path = "~/.ssh/id_rsa_consul"
    @app_server_ip = @deploy.site.app_server.ip
    @web_server_ip = @deploy.site.web_server.ip
    @db_server_ip = @deploy.site.db_server.ip
  end

  def run
    return "Can't run this deploy" unless @deploy.status == 'queued'

    return_value = nil
    log = nil

    @deploy.update_attributes!(started_at: Time.current, status: 'started')

    ActionCable.server.broadcast @deploy.cable_log_id, { status: @deploy.status }

    copy_deploy_files

    Bundler.with_clean_env do
      Dir.chdir @run_dir do
        return_value, log = CommandRunner.run_command("bundle install && bundle exec cap #{@environment} deploy", @deploy.cable_log_id)
      end
    end

    status = return_value.success? ? 'finished' : 'failed'
    @deploy.update_attributes!(finished_at: Time.current, status: status, log: log)

    ActionCable.server.broadcast @deploy.cable_log_id, { status: @deploy.status }

    return return_value.success?
  end

  private

  def copy_deploy_files
    File.write File.join(@run_dir, '.ruby-version'), '2.3.1'

    FileUtils.cp File.join(@recipe_dir, "Capfile"), File.join(@run_dir, "Capfile")

    FileUtils.cp File.join(@recipe_dir, "Gemfile_for_deploy"), File.join(@run_dir, "Gemfile")

    FileUtils.rm_rf File.join(@run_dir, "config/deploy/")
    FileUtils.mkdir_p File.join(@run_dir, "config/deploy/")

    template = File.read File.join(@template_dir, "config/deploy.rb.erb")
    file_content = ERB.new(template).result(binding)
    File.write(File.join(@run_dir, "config/deploy.rb"), file_content)

    template = File.read File.join(@template_dir, "config/deploy/staging.rb.erb")
    file_content = ERB.new(template).result(binding)
    File.write(File.join(@run_dir, "config/deploy/staging.rb"), file_content)

    template = File.read File.join(@template_dir, "config/deploy/production.rb.erb")
    file_content = ERB.new(template).result(binding)
    File.write(File.join(@run_dir, "config/deploy/production.rb"), file_content)
  end
end
