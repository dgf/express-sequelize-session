supertest = require 'supertest'

admin =
  login: 'admin@localhost'
  password: 'secret'

spec = (app, db) ->

  request = supertest app
  agent = supertest.agent app

  before (done) ->
    db.User.create(admin).done done

  it 'GET / public index page', (done) ->
    request.get('/').expect(200).expect('Content-Type', /html/).expect(/password/).end done

  it 'POST /login invalid', (done) ->
    request.post('/login').send(login: 'anonymous').expect(500).end done

  it 'POST /login success', (done) ->
    agent.post('/login').send(admin).expect(302).end done

  it 'GET /private unauthorized', (done) ->
    request.get('/private').expect(401).end done

  it 'GET /private authorized', (done) ->
    agent.get('/private').expect(200).expect(/Logout/).end done

  it 'GET /logout unauthorized', (done) ->
    request.get('/logout').expect(500).end done

  it 'GET /logout authorized', (done) ->
    agent.get('/logout').expect(302).end done

# init application and run spec
require('../example/express3/app') (err, app, db) ->
  if err? then throw err else
    describe 'express 3 integration test', ->
      spec app, db
