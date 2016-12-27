window.anoikis ||= {}

$(window).on "paste", (event) ->
  return if event.target.tagName.toLowerCase() is 'input'
  return if event.target.tagName.toLowerCase() is 'textarea'
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

$(document).on "change", "[name='signature\[group\]']", (event) ->
  event.preventDefault()
  sig_group = $(this)
  list = sig_group.closest("dl")
  if sig_group.val() is "wormhole"
    $(".optional", list).removeClass("hidden")
  else
    $(".optional", list).addClass("hidden")

$(document).on "turbolinks:load", ->
  $(".edit_signature").on "ajax:success", (e, data) ->
    anoikis.process_signatures(data)
  $(".new_signature").on "ajax:success", (e, data)->
    anoikis.process_signatures(data)
    new_sig = $(".new_signature")
    new_sig[0].reset()
    new_sig.find(".optional").addClass("hidden")
    new_sig.hide()
  $(".signatures").on "change", "[name='signature[group]']", ->
    type = "list--" + $(this).val() + "s"
    form = $(this).closest("form")
    $("[name='signature[name]']", form).attr("list", type)
  $("[name='signature[group]']").trigger("change")

anoikis.process_signatures = (data) ->
  return unless data.solar_system_id is anoikis.current_system_id
  switch data.type
    when "signatures"
      $(".signatures tbody").empty().append(data.signatures)
      # force the sigs to reapply the proper datalist
      $("[name='signature[group]']").trigger("change")
      return
    when "single_signature"
      if data.errors
        errors = "<p class='signatures__error'>#{data.errors.join("<br>")}</p>"
        $(".signatures--new td:first").prepend(errors)
      else
        $(".signatures__error").remove()
        selector = $(".signatures [data-signature-id=\"#{data.signature_id}\"]")
        index = selector.index()
        selector.remove()
        if $(".signatures tbody tr").length
          new_current_row = $(".signatures tbody tr:eq(#{index})")
          if new_current_row.length
            new_current_row.before(data.signature)
          else
            $(".signatures tbody tr:eq(#{index-1})").after(data.signature)
        else
          $(".signatures tbody").append(data.signature)
      # force the sigs to reapply the proper datalist
      $("[name='signature[group]']").trigger("change")
      return
    when "signature_removal"
      $(".signatures [data-signature-id=\"#{data.signature_id}\"]").remove()
      return
  return
