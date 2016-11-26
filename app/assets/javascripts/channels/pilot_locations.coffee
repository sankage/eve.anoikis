App.signatures = App.cable.subscriptions.create "PilotLocationsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.info "pilot location data received"
    anoikis.process_locations(data)
