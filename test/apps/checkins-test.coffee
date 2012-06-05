
assert  = require 'assert'
request = require 'request'
User    = require '../../models/user'
app     = require '../../server'

describe "checkins", ->
  describe "GET /", ->
    body = null
    before (done) ->
      options =
        uri: "http://localhost:#{app.settings.port}/"
      request options, (err, response, _body) ->
        body = _body
        done()

    it "has title", ->
      assert.hasTag body, '//h1', "We're all here!"
    it "has subtitle", ->
      assert.hasTag body, '//h2', "What about you, are you here?"
    it "has username field", ->
      assert.hasTag body, '//input[@name="username"]', ''
    it "has message field", ->
      assert.hasTag body, '//textarea[@name="message"]', ''
    it "has submit button", ->
      assert.hasTag body, '//input[@value="Check in!"]', ''

  describe "POST /check-in", ->
    describe "with valid attributes", -> 
      body = null
      before (done) ->
        options =
          uri: "http://localhost:#{app.settings.port}/check-in"
          form:
            username: 'John Carter'
            message: 'Dude! Where is my car!?'
          followAllRedirects: true
        request.post options, (err, response, _body) ->
          throw new Error(_body) if response.statusCode >= 400
          body = _body
          done()

      it "shows successfull checkin message", ->
        assert.hasTag body, "//div[@class='alert-box success']", "Welcome 'John Carter'! Thank you for this check in."
      it "saves the checkin in the DB", ->
        User.findById 'John-Carter', (err, user) ->
          assert.equal user.username, 'John Carter'
          assert.equal user.message, 'Dude! Where is my car!?'
      it "lists stored user", ->
        assert.hasTag body, '//li[@class="user"]/div[@class="message"]', 'Dude! Where is my car!?'
