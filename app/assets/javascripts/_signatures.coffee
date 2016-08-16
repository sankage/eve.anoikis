$(window).on "paste", (event) ->
  return if event.target.tagName.toLowerCase() is 'input'
  event.preventDefault()
  data = if window.clipboardData
    window.clipboardData.getData("Text")
  else
    (event.originalEvent || event).clipboardData.getData('text/plain')
  return unless data
  signatures = process_clipboard_data(data)
  return if signatures[0].sig_id.length isnt 7
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

$(document).on "click", "[data-trigger]", (event) ->
  event.preventDefault()
  sig_id = $(this).data('trigger')
  $(".signatures--edit[data-signature-id=\"#{sig_id}\"]").toggle()
  $(".signatures--show[data-signature-id=\"#{sig_id}\"]").toggle()
  if sig_id is "new_sig"
    $(".signatures--new form").toggle()
