connect = require('connect')
Sequelize = require 'sequelize'

{aCheck} = require 'ajsh'
C3Store = require('../src/c3store') connect
spec = require './store.spec.template'

sqlSpec = (db) ->
  #
  describe 'Sequelize session store implementation', ->
    #
    spec (sessions) ->
      store = new C3Store db, optional:
        type: Sequelize.STRING
      it 'syncs the model and session data', ->
        sync = (done) -> store.SequelizeSession.sync(force: true).success done
        aCheck 'sync model', sync, 50

        for own sid of sessions
          do (sid) -> aCheck 'save session', (done) ->
            store.set sid, sessions[sid], done

      store

describe 'MySQL', -> sqlSpec new Sequelize 'c3s_test', 'travis', '', logging: false
describe 'sqlite3', -> sqlSpec new Sequelize 'session', 'sa', 'secret',
  logging: false
  dialect: 'sqlite'
