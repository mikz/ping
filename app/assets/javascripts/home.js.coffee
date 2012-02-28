# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

USER_HTML = """
             <li>{{name}}</li>
            """

jQuery.ajax
  url: '/pongs'
  data: { last_poll: 'dsfd'}
  success: ->
    user = { name: "Someone", image_url: "https://en.gravatar.com/userimage/11287998/c22081c0690844cd84879f3072a3c6b3.jpg" }
    el = $($.mustache(USER_HTML, user))

  error: ->
    console.info "You lost a ping pong game."