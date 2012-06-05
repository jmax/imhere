
assert = require 'assert'
redis  = require('redis').createClient()
User   = require '../../models/user'

describe 'User', ->
  describe 'create', ->
    user = null
    before ->
      user = new User { username: 'John Foo', message: 'Dude! Where is my car!' }
    it "sets username", ->
      assert.equal user.username, 'John Foo'
    it "sets message", ->
      assert.equal user.message, 'Dude! Where is my car!'
    it "generates Id", ->
      assert.equal user.id, 'John-Foo'

  describe 'persistence', ->
    it "builds a key for each environment", ->
      assert.equal User.key(), "User:#{process.env.NODE_ENV}"

    describe "save", ->
      user = null
      before (done) ->
        user = new User { username: 'Bruce Wayne' }
        user.save ->
          done()
      it "returns an User object", ->
        assert.instanceOf user, User

    describe "findById", ->
      user = null
      before (done) ->
        new_user = new User { username: 'John Carter' }
        new_user.save () ->
          done()

        User.findById 'John-Carter', (err, _user) ->
          user = _user

      it "returns an existing User", ->
        assert.instanceOf user, User
      it "fetches the correct object", ->
        assert.equal user.username, 'John Carter'

    afterEach ->
      redis.del User.key()
