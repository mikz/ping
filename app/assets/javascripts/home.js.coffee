window.poll_pongs = ->
  jQuery.ajax
    url: '/pongs'
    data: { last_poll: window.last_poll, scope: 'friends' }
    success: (response) ->
      window.last_poll = response.last_poll

      _.each response.pongs, (pong) ->
        window.pongs.add
          name: pong.id
          name: pong.name
          city: 'Prague'

      window.setTimeout(poll_pongs, 2000)
      window.pongs.sort 'id', { asc: false }

    error: ->
      console.info "You lost a ping pong game."
