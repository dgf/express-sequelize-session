spec = require './store.spec.template'
MemStore = require('./in-memory-store') require('connect')

describe 'in memory session store implementation', ->
  spec (sessions) ->
    store = new MemStore
    store.set sid, sessions[sid] for own sid of sessions
    store
