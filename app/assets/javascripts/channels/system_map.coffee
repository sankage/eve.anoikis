App.signatures = App.cable.subscriptions.create "SystemMapChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.info "system map received"
    anoikis.process_system_map(data)
