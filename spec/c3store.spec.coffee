connect = require('connect')
Sequelize = require 'sequelize'

aCheck = require './checker'
C3Store = require('../src/c3store') connect
spec = require './store.spec.template'

describe 'Sequelize session store implementation', ->
  db = new Sequelize 'checkfoo', 'root', '', logging: false

  # @todo write spec to use sqlite
  # in Database#all('SELECT * FROM `Sessions` WHERE `sid`=\'sid1\' LIMIT 1;', [Function])
  # => SyntaxError: Unexpected token \
  #db = new Sequelize 'session-store', 'sa', 'secret',
  #  logging: false,
  #  dialect: 'sqlite'
  #  storage: 'foo.db'
  #  storage: ':memory:'

  spec (sessions) ->
    store = new C3Store db, optional: type: Sequelize.STRING
    sync = (done) -> store.SequelizeSession.sync(force: true).success(done)
    aCheck 'sync model', sync, 50

    for own sid of sessions
      do (sid) -> aCheck 'save session', (done) ->
        store.set sid, sessions[sid], done

    store
