require 'open3'

class CommandRunner
  def self.run_command(command, cable_log_id=nil)
    return_value = nil
    log = ""

    Open3.popen2e(command) do |stdin, stdout_and_stderr, wait_thr|
      stdout_and_stderr.each do |line|
        puts line
        send_cable(line, cable_log_id) if cable_log_id
        log << line
      end
      return_value = wait_thr.value
    end

    return return_value, log
  end

  def self.send_cable(line, cable_log_id)
    ActionCable.server.broadcast cable_log_id, {
      log_line: line
    }
  end
end
