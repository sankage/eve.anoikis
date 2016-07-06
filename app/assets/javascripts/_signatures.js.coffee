$(window).on "paste", (event) ->
  event.preventDefault()
  data = if window.clipboardData
    window.clipboardData.getData("Text")
  else
    (event.originalEvent || event).clipboardData.getData('text/plain')
  return unless data
  signatures = process_clipboard_data(data)
  $.ajax
    url: "#{window.location.href}/signatures/batch_create.json"
    method: "POST"
    data: JSON.stringify { signatures: signatures }
    dataType: 'json'
    contentType: 'application/json'


process_clipboard_data = (data) ->
  rows = data.split("\n")
  rows.map (row) ->
    parts = row.split("\t")
    {
      sig_id: parts[0]
      type: parts[1]
      group: parts[2]
      name: parts[3]
      strength: parts[4]
      distance: parts[5]
    }
