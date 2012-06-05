
User = require('../../models/user')

routes = (app) ->

  app.get '/', (req, res) ->
    res.render "#{__dirname}/views/checkin",
      title: "We're all here!"
      subtitle: "What about you, are you here?"

  app.post '/check-in', (req, res) ->
    attributes =
      username: req.body.username
      message: req.body.message
    user = new User attributes
    user.save () ->
      if socketIO = app.settings.socketIO
        socketIO.sockets.emit "user:checkedin", user
      req.flash 'success', "Welcome '#{user.username}'! Thank you for this check in."
      res.redirect '/dashboard'

module.exports = routes
