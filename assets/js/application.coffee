#= require jquery.min.js
#= require underscore-min.js
#= require modernizr.foundation.js
#= require foundation.js
#= app.js

jQuery ->
  # Home page
  if window.location.pathname is '/dashboard'
    refresh = ->
      window.location = '/dashboard'

    socket = io.connect("/")
    socket.on "user:checkedin", (user) ->
      refresh()
 
    setTimeout refresh, 1000*60

    # DEBUG
    window.socket = socket
