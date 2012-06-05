
redis = require('redis').createClient()

class User

  @key: ->
    "User:#{process.env.NODE_ENV}"

  @findById: (id, callback) ->
    redis.hget User.key(), id, (err, json) ->
      if json is null
        callback new Error("User '#{id}' could not be found.")
        return
      user = new User JSON.parse(json)
      callback null, user

  @all: (callback) ->
    redis.hgetall User.key(), (err, objects) ->
      users = []
      for key, value of objects
        user = new User JSON.parse(value)
        users.push user
      callback null, users

  constructor: (attributes) ->
    @[key] = value for key, value of attributes
    @generateId()
    @

  generateId: ->
    if not @id and @username
      @id = @username.replace /\s/g, '-'

  save: (callback) ->
    @generateId
    redis.hset User.key(), @id, JSON.stringify(@), (err, code) =>
      callback null, @

module.exports = User
