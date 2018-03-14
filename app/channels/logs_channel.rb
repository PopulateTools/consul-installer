class LogsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params['cable_log_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
