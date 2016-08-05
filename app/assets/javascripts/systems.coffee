window.anoikis ||= {}
google.charts.load('current', { packages:["orgchart"] })

anoikis.drawChart = ->
  data = new google.visualization.DataTable()
  data.addColumn('string', 'Name')
  data.addColumn('string', 'Parent')

  data.addRows($("#mapper").data("map"))

  anoikis.chart = new google.visualization.OrgChart(document.getElementById('mapper'))
  anoikis.chart.draw(data, {
    allowHtml: true,
    allowCollapse: true,
    nodeClass: "node",
    selectedNodeClass: "node--selected" })

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

  locations = $.ajax
    url: "/pilot_locations.json"
    method: "get"
    contentType: "application/json"
  locations.done (data) ->
    divs = []
    $.each data, (location, pilots) ->
      div = $("<div />")
      list = $("<ul></ul>")
      $.each pilots, (_, pilot) ->
        list.append("<li>#{pilot}</li>")
      div.append("<h2>#{location}</h2>", list)
      divs.push(div)
    $(".pilot_locations--list").empty().append(divs)
    $(".pilot_locations").show()
