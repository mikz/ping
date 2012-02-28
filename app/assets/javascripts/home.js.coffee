window.poll_pongs = ->
  jQuery.ajax
    url: '/pongs'
    data: { last_poll: '1212112'}
    success: (pongs) ->
      window.pongs.add
        name: 'lsdjf'
        city: 'sldjfldsfjlsd'

    error: ->
      console.info "You lost a ping pong game."
