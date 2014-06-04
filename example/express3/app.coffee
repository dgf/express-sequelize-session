# load dependencies
express = require 'express'
Sequelize = require 'sequelize'
C3Store = require('../../src/c3store') express.session.Store

# use in-memory SQLite3 database
sequelize = new Sequelize 'itest', 'sa', 'secret', dialect: 'sqlite', logging: false
store = new C3Store sequelize, 'session'

# define an user table
User = sequelize.define 'user',
  login:
    type: Sequelize.STRING
    allowNull: false
    unique: true
  password:
    type: Sequelize.STRING
    allowNull: false
    unique: true

# associate session user
User.belongsTo store.Session, foreignKeyConstraint: true

# process a login request, reference the session and yield the user
login = (req, done) ->
  q = where: login: req.body.login, password: req.body.password
  User.find(q).done (err, user) ->
    if err? then done err
    else if not user then done new Error 'login failed'
    else store.Session.findOrCreate(sid: req.sessionID).done (err, session) ->
      if err? then done err else user.setSession(session).done done

# process a logout request
logout = (req, done) ->
  User.find(where: login: req.session.user).done (err, user) ->
    if err? then done err
    else if not user then done new Error 'logout failed'
    else user.setSession(null).done done

# create and configure express app
app = express()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
  key: 'sid'
  secret: 'MyAwesomeAppSessionSecret'
  store: store

# activate router
app.use app.router

# restrict all requests
app.all '*', (req, res, next) ->
  if req.path in ['/', '/login', '/logout']
    next() # always allow access of these resources
  else # check user session
    if req.session.user
      next() # authenticated request
    else
      res.send 401 # unauthorized

# public index page with login form
app.get '/', (req, res) ->
  res.send """
    <html><head><title>restricted area</title></head><body>
    <form action="/login" method="POST">
      <label>Login <input type="text" name="login"/></label>
      <label>Password <input type="password" name="password"/></label>
      <button type="submit">Login</button>
    </form></body></html>
  """

# validate login and redirect
app.post '/login', (req, res, next) ->
  login req, (err, user) ->
    if err? then next err else # re-ref user login
      req.session.user = user.login
      res.redirect '/private'

# logout and redirect
app.get '/logout', (req, res, next) ->
  logout req, (err) ->
    if err? then next err else
      delete req.session.user # de-ref user for safety
      req.session.destroy ->
        res.redirect '/'

# private content page
app.get '/private', (req, res) ->
  res.send """
    <html><head><title>private space</title></head><body>
    <h1>Welcome #{req.session.user}</h1>
    <p>nice 2 cu</p>
    <a href="/logout">Logout</a>
    </body></html>
  """

# export database and express app
module.exports = (done) ->
  sequelize.sync(force: true).done (err) ->
    if err? then done err else done null, app,
      Session: store.Session
      User: User
