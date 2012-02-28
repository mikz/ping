$ ->

  with_geo = (data) ->
    console.log(data)
    $.post('/pongs', data)

  without_geo = ->
    $.post('/pongs')

  $('#ping-button').on 'click', ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(with_geo, without_geo)
    else
      without_geo()
