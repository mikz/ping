window.poll_pongs = ->
  jQuery.ajax
    url: '/pongs'
    data: { last_poll: window.last_poll, scope: window.scope }
    success: (response) ->
      window.last_poll = response.last_poll

      _.each response.pongs, (pong) ->
        item = window.pongs.add
          name: pong.user.name || "Anon"
          city: '&hellip;'
          timestamp: pong.created_at

        item = $(item[0].elm)
        img = $("<img>", src:  pong.user.image_url)
        item.find(".userPic").append(img)
        time = item.find(".timestamp")
        time.text($.timeago(time.text()))


      window.setTimeout(poll_pongs, 2000)

    error: ->
      console.info "You lost a ping pong game."
