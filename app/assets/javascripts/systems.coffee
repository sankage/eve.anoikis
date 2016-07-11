window.anoikis ||= {}
google.charts.load('current', { packages:["orgchart"] })

anoikis.drawChart = ->
  data = new google.visualization.DataTable()
  data.addColumn('string', 'Name')
  data.addColumn('string', 'Parent')

  data.addRows($("#mapper").data("map"))

  anoikis.chart = new google.visualization.OrgChart(document.getElementById('mapper'))
  anoikis.chart.draw(data, { allowHtml: true })

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

  google.charts.setOnLoadCallback(anoikis.drawChart)
