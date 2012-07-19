connect = require('connect')
Sequelize = require 'sequelize'

aCheck = require './checker'
C3Store = require('../src/c3store') connect
spec = require './store.spec.template'


sqlSpec = (db) ->
  #
  describe 'Sequelize session store implementation', ->
    #
    spec (sessions) ->
      store = new C3Store db, optional:
        type: Sequelize.STRING
      sync = (done) -> store.SequelizeSession.sync(force: true).success(done)
      aCheck 'sync model', sync, 50

      for own sid of sessions
        do (sid) -> aCheck 'save session', (done) ->
          store.set sid, sessions[sid], done

      store

xdescribe 'MySQL', -> sqlSpec new Sequelize 'session', 'root', '', logging: false
describe 'sqlite3', -> sqlSpec new Sequelize 'session', 'sa', 'secret',
  logging: false
  dialect: 'sqlite'
