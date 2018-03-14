$(document).on "turbolinks:load", ->
  log_id = $('#log-output').data("log-id")

  App.logs = App.cable.subscriptions.create { channel: "LogsChannel", cable_log_id: log_id },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      if data['status']
        $('span#status').html(data['status'])

      $('#log-output pre').append(data['log_line'])

