window.anoikis ||= {}
google.charts.load('current', { packages:["orgchart"] })

anoikis.drawChart = ->
  data = new google.visualization.DataTable()
  data.addColumn('string', 'Name')
  data.addColumn('string', 'Parent')

  connection_map = $("#mapper .connection_map")

  rows = connection_map.data("map")
  selected = connection_map.data("selected") + ""
  for row in rows
    row_index = data.addRow(row)
    selected_row = row_index if row[0]["v"] is selected

  anoikis.chart = new google.visualization.OrgChart(connection_map[0])
  anoikis.chart.draw(data, {
    allowHtml: true,
    allowCollapse: true,
    nodeClass: "node",
    selectedNodeClass: "node--selected" })
  anoikis.chart.setSelection([{ row: selected_row }])

anoikis.process_signature_json = (data) ->
  if data.type is "signatures"
    $(".signatures tbody").empty().append(data.signatures)
  if data.signature_id
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
  if data.system_map
    $("#mapper").empty().append(data.system_map)
    anoikis.drawChart()
  if data.type is "locations"
    divs = []
    $.each data.locations, (location, pilots) ->
      div = $("<div />")
      list = $("<ul></ul>")
      $.each pilots, (_, pilot) ->
        list.append("<li>#{pilot}</li>")
      div.append("<h2>#{location}</h2>", list)
      divs.push(div)
    $(".pilot_locations--list").empty().append(divs)
    $(".pilot_locations").show()


$(document).on "turbolinks:load", ->
  systems = $.ajax
    url: "/systems/system_names.json"
    method: "get"
    contentType: "application/json"
  systems.done (data) ->
    options = data.systems.map (name) -> "<option value='#{name}'>"
    $("<datalist id='systems'></datalist>").append(options).appendTo("body")
    options = data.wormhole_types.map (name) -> "<option value='#{name}'>"
    $("<datalist id='wormhole_types'></datalist>").append(options).appendTo("body")

  google.charts.setOnLoadCallback(anoikis.drawChart)

  $(".edit_signature").on "ajax:success", (e, data) ->
    anoikis.process_signature_json(data)
