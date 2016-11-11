$(document).on "turbolinks:load", ->
  update_sig_ages = ->
    $(".active_time").each ->
      [hours, minutes] = $(this).text().split(":")
      hours = parseInt(hours, 10)
      minutes = parseInt(minutes, 10)
      minutes += 1
      if minutes is 60
        minutes = 0
        hours += 1
      if minutes < 10
        minutes = "0" + minutes
      $(this).text([hours, minutes].join(":"))
    $(".time_to_die").each ->
      [hours, minutes] = $(this).text().split(":")
      hours = parseInt(hours, 10)
      minutes = parseInt(minutes, 10)
      minutes -= 1
      if minutes is -1
        minutes = 59
        hours -= 1
      if minutes < 10
        minutes = "0" + minutes
      $(this).text([hours, minutes].join(":"))
  window.setInterval(update_sig_ages, 60000)
