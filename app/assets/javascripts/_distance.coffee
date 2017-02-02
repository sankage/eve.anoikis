window.anoikis ||= {}

class BFS
  constructor: (@list) ->
  shortest_path: (start, finish) ->
    nodes = @node_setup(@list)
    queue = []
    root = nodes[start]
    root.distance = 0
    queue.push root
    while (queue.length > 0)
      current = queue.shift()
      return current.distance if current is nodes[finish]
      for neighbor in current.neighbors
        if nodes[neighbor].distance == @maxint
          nodes[neighbor].distance = current.distance + 1
          nodes[neighbor].parent = current
          queue.push nodes[neighbor]
  node_setup: (list) ->
    result = {}
    for own node, next of list
      result[node] = {
        neighbors: next
        distance: @maxint
        parent: null
      }
    return result
  maxint: Number.POSITIVE_INFINITY

activate_distance_ui = ->
  # Find all k-space connections in the map and use them as the source
  map_data = $("#mapper .connection_map").data("map")
  kspace_nodes = []
  sources = []
  for node in map_data
    string = node[0].f
    matches = string.match(/node__information--(ls|hs|ns).*<h2>(.*)<\/h2>/)
    if matches
      kspace = {
        system_id: parseInt(node[0].v, 10)
        type: matches[1]
        name: matches[2].trim()
      }
      kspace_nodes.push kspace
      sources.push """
                   <li data-system-id="#{kspace.system_id}"
                       class="source source--#{kspace.type}">
                     #{kspace.name}
                     <span class="distance"></span>
                   </li>
                   """
  $(".distance_ui .sources ul").empty().append(sources)
  # Add select options based on the system ids passed along with the adjacency
  # list
  options = []
  for system in anoikis.bfs_ids
    options.push "<option value='#{system[0]}'>#{system[1]}</option>"
  $(".distance_ui .actions select").empty().append(options)
  # Only reveal the distance ui if there are kspace nodes in the connection map
  if kspace_nodes.length
    $(".distance_ui").removeClass("hidden")
  $(".distance_calculation").on "click", (event) ->
    event.preventDefault()
    desto = $("#destination").val()
    for kspace in kspace_nodes
      distance = anoikis.bfs.shortest_path(kspace.system_id - 30000000, desto)
      selector = ".distance_ui .sources [data-system-id='#{kspace.system_id}'] .distance"
      $(selector).text " > #{distance} jumps"


$(document).on "turbolinks:load", ->
  connections = $.ajax
    url: "/connections.json"
    method: "get"
    contentType: "application/json"
  connections.done (data) ->
    anoikis.bfs = new BFS(data.connections)
    anoikis.bfs_ids = data.system_ids
  connections.done (data) -> activate_distance_ui()
