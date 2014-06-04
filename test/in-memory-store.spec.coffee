connect = require 'connect'
spec = require './store.spec.template.coffee'
MemStore = require('./in-memory-store') connect.session.Store

describe 'in memory session store implementation', ->
  spec (sessions) ->
    store = new MemStore
    store.set sid, sessions[sid] for own sid of sessions
    store
