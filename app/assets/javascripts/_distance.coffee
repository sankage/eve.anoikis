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
  $(".distance_ui").removeClass("hidden")

$(document).on "turbolinks:load", ->
  connections = $.ajax
    url: "/connections.json"
    method: "get"
    contentType: "application/json"
  connections.done (data) -> anoikis.bfs = new BFS(data)
  connections.done (data) -> activate_distance_ui()
