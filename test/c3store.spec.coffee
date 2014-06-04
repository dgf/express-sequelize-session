_ = require 'lodash'
async = require 'async'
connect = require 'connect'
Sequelize = require 'sequelize'

C3Store = require('../src/c3store') connect.session.Store
spec = require './store.spec.template.coffee'

sqlSpec = (db) ->

  describe 'Sequelize session store implementation', ->

    store = new C3Store db, 'test_session_table',
      optional:
        type: Sequelize.STRING
        allowNull: true

    spec (sessions) ->

      it 'syncs the model', (done) ->
        store.Session.sync(force: true).done done

      it 'loads session fixtures', (done) ->
        save = (sid, done) -> store.set sid, sessions[sid], done
        async.forEachSeries _.keys(sessions), save, done

      # return initialized test store
      store

describe 'MySQL', ->
  sqlSpec new Sequelize 'c3s_test', 'travis', '',
    logging: false

describe 'PostgreSQL', ->
  sqlSpec new Sequelize 'c3s_test', 'postgres', '',
    dialect: 'postgres'
    logging: false

describe 'sqlite3', ->
  sqlSpec new Sequelize 'session', 'sa', 'secret',
    dialect: 'sqlite'
    logging: false
