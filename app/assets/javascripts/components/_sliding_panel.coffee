$(document).on 'click touchstart', '.sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close', (event) ->
  $('.sliding-panel-content,.sliding-panel-fade-screen').toggleClass('is-visible')
  if !$('.sliding-panel-content,.sliding-panel-fade-screen').hasClass("is-visible")
    $('.expander-trigger').addClass("expander-hidden")
  event.preventDefault()
