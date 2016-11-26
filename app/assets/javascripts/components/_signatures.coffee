$(document).on "turbolinks:load", ->
  update_sig_ages = ->
    $(".active_time").each ->
      created_at = Date.parse($(this).attr("datetime"))
      time_passed = Date.now() - created_at
      minutes = parseInt((time_passed/(1000*60))%60, 10)
      hours = parseInt((time_passed/(1000*60*60)), 10)
      minutes = if (minutes < 10) then "0" + minutes else minutes
      hours = if (hours < 10) then "0" + hours else hours
      $(this).text([hours, minutes].join(":"))
    $(".time_to_die").each ->
      eol_at = Date.parse($(this).attr("datetime"))
      dead_at = eol_at + (4 * 60 * 60 * 1000)
      time_to_death = dead_at - Date.now()
      minutes = parseInt((Math.abs(time_to_death)/(1000*60))%60, 10)
      hours = parseInt((Math.abs(time_to_death)/(1000*60*60)), 10)
      minutes = if (minutes < 10) then "0" + minutes else minutes
      hours = if (hours < 10) then "0" + hours else hours
      if time_to_death < 0
        hours = "-#{hours}"
      $(this).text([hours, minutes].join(":"))
  window.setInterval(update_sig_ages, 60000)
