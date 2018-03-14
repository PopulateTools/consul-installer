class ServerSetupJob < ApplicationJob
  queue_as :default

  def perform(server_setup_id)
    server_setup = ServerSetup.find(server_setup_id)
    ServerSetupRunner.new(server_setup).run
  end
end
