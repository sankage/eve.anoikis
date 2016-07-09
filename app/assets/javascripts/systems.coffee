$(document).on "turbolinks:load", ->
  ajax = $.ajax
    url: "/systems/system_names.json"
    method: "get"
    contentType: "application/json"
  ajax.done (data) ->
    options = data.systems.map (name) -> "<option value='#{name}'>"
    $("<datalist id='systems'></datalist>").append(options).appendTo("body")
    options = data.wormhole_types.map (name) -> "<option value='#{name}'>"
    $("<datalist id='wormhole_types'></datalist>").append(options).appendTo("body")
