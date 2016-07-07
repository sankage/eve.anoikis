App.signatures = App.cable.subscriptions.create "SignaturesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.signatures
      $(".signatures tbody").empty().append(data.signatures)
    if data.signature
      selector = $(".signatures [data-signature-id=\"#{data.signature_id}\"]")
      index = selector.index()
      selector.remove()
      $(".signatures tbody tr:eq(#{index})").before(data.signature)
