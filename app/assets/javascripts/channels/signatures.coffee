App.signatures = App.cable.subscriptions.create "SignaturesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.type is "signatures"
      $(".signatures tbody").empty().append(data.signatures)
    if data.signature_id
      selector = $(".signatures [data-signature-id=\"#{data.signature_id}\"]")
      index = selector.index()
      selector.remove()
      if $(".signatures tbody tr").length
        $(".signatures tbody tr:eq(#{index})").before(data.signature)
      else
        $(".signatures tbody").append(data.signature)
    if data.system_map
      $("#mapper").empty().append(data.system_map)
      anoikis.drawChart()
