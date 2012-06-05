
User = require('../../models/user')

routes = (app) ->

  app.get "/dashboard", (req, res) ->
    User.all (err, users) ->
      res.render "#{__dirname}/views/dashboard",
        title: "Dashboard"
        subtitle: "People in the house"
        users: users

module.exports = routes
