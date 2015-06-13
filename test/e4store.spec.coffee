_ = require 'lodash'
async = require 'async'
expressSession = require 'express-session'
Sequelize = require 'sequelize'

E4Store = require('../src/e4store') expressSession.Store
spec = require './store.spec.template.coffee'

sqlSpec = (db) ->

  describe 'Express Sequelize session store', ->

    store = new E4Store db, 'test_session_table',
      optional:
        type: Sequelize.STRING
        allowNull: true

    spec (sessions) ->

      it 'syncs the model', (done) ->
        store.Session.sync
          force: true
        .then ->
          done null
        .catch (err) ->
          done err

      it 'loads session fixtures', (done) ->
        save = (sid, next) ->
          store.set sid, sessions[sid], (err) ->
            if err? then next err else next null
        async.forEachSeries _.keys(sessions), save, done

      # return initialized test store
      store

describe 'MySQL', ->
  sqlSpec new Sequelize 'e4s_test_mysql', 'travis', '',
    logging: false

describe 'PostgreSQL', ->
  sqlSpec new Sequelize 'e4s_test_postgres', 'postgres', '',
    dialect: 'postgres'
    logging: false

describe 'sqlite3', ->
  sqlSpec new Sequelize 'e4s_test_sqlite', 'sa', 'secret',
    dialect: 'sqlite'
    logging: false
