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
  set_selection_override = -> anoikis.chart.setSelection([{ row: selected_row }])
  google.visualization.events.addListener anoikis.chart, 'ready', set_selection_override
  google.visualization.events.addListener anoikis.chart, 'select', set_selection_override

  anoikis.chart.draw(data, {
    allowHtml: true,
    allowCollapse: true,
    nodeClass: "node",
    selectedNodeClass: "node--selected" })

  $(".node__information").each ->
    node = $(this)
    status = node.data("status")
    if status.length
      anoikis.mark_line(node.data("node"), node.data("parent"), status)

anoikis.process_signature_json = (data) ->
  if data.solar_system_id is anoikis.current_system_id
    if data.system_map
      $("#mapper").empty().append(data.system_map)
      anoikis.drawChart()
  switch data.type
    when "signatures"
      if data.solar_system_id is anoikis.current_system_id
        $(".signatures tbody").empty().append(data.signatures)
      # force the sigs to reapply the proper datalist
      $("[name='signature[group]']").trigger("change")
      return
    when "single_signature"
      if data.solar_system_id is anoikis.current_system_id
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
    when "locations"
      $("[data-node] .pilots").removeClass("active")
      divs = []
      opens = new Set($(".pilot_locations--list").data('open'))
      $.each data.locations, (location, pilots) ->
        [system_id, system_name, type] = location.split("|")
        system_id = parseInt(system_id, 10)
        div = $("<div class='expander' />")
        list = $("<ul class='expander-content'></ul>")
        $.each pilots, (_, pilot) ->
          list.append("<li>#{pilot}</li>")
        classes = ["expander-trigger", "expander-hidden"]
        classes.pop() if opens.has(system_id)
        h2 = $("<h2></h2>", {
          "class": classes.join(' ')
          data: { "system-id": system_id }
          text: system_name
        })
        if type is "k"
          h2.append("<a href='/systems/#{system_id}/set_destination' data-remote='true'>Set Desto</a>")
        div.append(h2, list)
        divs.push(div)
        $("[data-node='#{system_id}'] .pilots").addClass("active")
      $(".pilot_locations--list").empty().append(divs)
      $(".pilot_locations").show()
      return
    when "signature_removal"
      if data.solar_system_id is anoikis.current_system_id
        $(".signatures [data-signature-id=\"#{data.signature_id}\"]").remove()
      return

$(document).on "click", ".pilot_locations--list .expander-trigger", ->
  system_id = $(this).data("system-id")
  opens = new Set($(".pilot_locations--list").data('open'))
  if $(this).hasClass "expander-hidden"
    opens.add(system_id)
  else
    opens.delete(system_id)
  $(".pilot_locations--list").data('open', Array.from(opens))
  return
$(document).on "click", ".connection_map [data-node] .pilots", (event) ->
  event.preventDefault()
  event.stopImmediatePropagation()
  system_id = $(this).closest(".node__information").data("node")
  $(".sliding-panel-button").trigger("click")
  $(".expander-trigger[data-system-id='#{system_id}']").trigger("click")
  return

anoikis.mark_line = (node, parent, status) ->
  status_vertical = status.split(" ").map( (i) -> return i + "-vertical" ).join(" ")
  node_cell = $("[data-node='#{node}']").parent()
  node_index = Math.ceil((node_cell[0].cellIndex + 1) / 2 - 1)
  node_row = $("[data-node='#{node}']").closest("tr")
  node_conn_bottom = node_row.prev()
  node_conn_top = node_conn_bottom.prev()
  vertical_classes = ".google-visualization-orgchart-lineleft, .google-visualization-orgchart-lineright"
  node_conn_bottom.children(vertical_classes).eq(node_index).addClass(status_vertical)
  grouped_siblings = find_sibling_positions(node_conn_bottom, node_conn_top)
  siblings_position = [].concat.apply([], grouped_siblings)

  index = 0
  for group, group_index in grouped_siblings
    for number in group
      if node_index is index
        if group.length is 1
          group_start = grouped_siblings[group_index]
          group_end = group_start
        else
          [group_start, x..., group_end] = grouped_siblings[group_index]
      index += 1
  parent_positions = node_conn_top.children(vertical_classes).map (_,e) -> e.cellIndex
  for position, index in parent_positions
    if position >= group_start and position <= group_end
      parent_position = position

  node_position = siblings_position[node_index]
  if node_position > parent_position
    if siblings_position[node_index-1] > parent_position
      start = siblings_position[node_index-1] + 1
    else
      start = parent_position
      node_conn_top.children().eq(parent_position).addClass(status_vertical)
    end = node_position + 1
  else
    start = node_position
    if siblings_position[node_index+1] < parent_position
      end = siblings_position[node_index+1]
    else
      end = parent_position
      node_conn_top.children().eq(parent_position).addClass(status_vertical)

  node_conn_top.children().slice(start, end).addClass(status)
  return

find_sibling_positions = (node_conn_bottom, node_conn_top) ->
  bottom_count = 0
  siblings_position = []
  $("td", node_conn_bottom).slice(1, -1).each ->
    bottom_count += this.colSpan
    cell = $(this)
    if cell.hasClass("google-visualization-orgchart-lineleft") ||
       cell.hasClass("google-visualization-orgchart-lineright")
      siblings_position.push(bottom_count)
  top_count = 0
  top_spacers = []
  $("td", node_conn_top).slice(1, -1).each ->
    top_count += this.colSpan
    cell = $(this)
    if this.colSpan > 1
      top_spacers.push(top_count + "|" + (this.colSpan - 1))
  sub_groups = []
  cumilative_space = 0;
  for spacer in top_spacers
    [base, negative] = spacer.split("|").map (n) -> parseInt(n, 10)
    sub_groups.push siblings_position.splice(0, siblings_position.indexOf(base-cumilative_space+1))
    siblings_position = siblings_position.map (s) -> (s - negative)
    cumilative_space += negative
  sub_groups.push siblings_position
  return sub_groups

$(document).on "turbolinks:load", ->
  anoikis.current_system_id = $("body").data("current-system-id")
  systems = $.ajax
    url: "/static.json"
    method: "get"
    contentType: "application/json"
  systems.done (data) ->
    lists = []
    options = data.systems.map (name) -> "<option value='#{name}'>"
    lists.push $("<datalist id='list--wormholes'></datalist>").append(options)
    options = data.wormhole_types.map (name) -> "<option value='#{name}'>"
    lists.push $("<datalist id='list--wormhole_types'></datalist>").append(options)
    options = data.combat_sites.map (name) -> "<option value='#{name}'>"
    lists.push $("<datalist id='list--combat_sites'></datalist>").append(options)
    options = data.data_sites.map (name) -> "<option value='#{name}'>"
    lists.push $("<datalist id='list--data_sites'></datalist>").append(options)
    options = data.relic_sites.map (name) -> "<option value='#{name}'>"
    lists.push $("<datalist id='list--relic_sites'></datalist>").append(options)
    options = data.gas_sites.map (name) -> "<option value='#{name}'>"
    lists.push $("<datalist id='list--gas_sites'></datalist>").append(options)
    $("body").append(lists)

  google.charts.setOnLoadCallback(anoikis.drawChart)

  $(".edit_signature").on "ajax:success", (e, data) ->
    anoikis.process_signature_json(data)
  $(".new_signature").on "ajax:success", (e, data)->
    anoikis.process_signature_json(data)
    new_sig = $(".new_signature")
    new_sig[0].reset()
    new_sig.find(".optional").addClass("hidden")
    new_sig.hide()
  $(".signatures").on "change", "[name='signature[group]']", ->
    type = "list--" + $(this).val() + "s"
    form = $(this).closest("form")
    $("[name='signature[name]']", form).attr("list", type)
  $("[name='signature[group]']").trigger("change")
