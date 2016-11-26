window.anoikis ||= {}

anoikis.process_locations = (data) ->
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
      attr: { "data-system-id": system_id }
      text: system_name
    })
    if type is "k"
      h2.append("<a href='/systems/#{system_id}/set_destination' data-remote='true'>Set Desto</a>")
    div.append(h2, list)
    divs.push(div)
    $("[data-node='#{system_id}'] .pilots").addClass("active")
  link = $("<a></a>", {
    "class": "pilot_locations__show_all"
    href: "javascript:void(0)"
    text: "Toggle all systems"
    on:
      click: (event) ->
        event.preventDefault()
        list = $(".pilot_locations--list")
        opens = $.map $(".expander-trigger", list), (trigger, _) ->
          !$(trigger).hasClass("expander-hidden")
        some_open = opens.some (val) -> val
        every_open = opens.every (val) -> val
        if some_open and not every_open
          $(".expander-trigger.expander-hidden", list).trigger("click")
        else
          $(".expander-trigger", list).trigger("click")
        return
  })
  divs.push link
  $(".pilot_locations--list").empty().append(divs)
  $(".pilot_locations").show()
  return
