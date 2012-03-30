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
      store = new C3Store db, optional: type: Sequelize.STRING
      sync = (done) -> store.SequelizeSession.sync(force: true).success(done)
      aCheck 'sync model', sync, 50

      for own sid of sessions
        do (sid) -> aCheck 'save session', (done) ->
          store.set sid, sessions[sid], done

      store

describe 'MySQL', -> sqlSpec new Sequelize 'checkfoo', 'root', '', logging: false
xdescribe 'sqlite3', -> sqlSpec new Sequelize 'session-store', 'sa', 'secret',
  #logging: false
  dialect: 'sqlite'
  storage: 'foo.db'
#  storage: ':memory:'
# in Database#all('SELECT * FROM `Sessions` WHERE `sid`=\'sid1\' LIMIT 1;', [Function])
# => SyntaxError: Unexpected token \
