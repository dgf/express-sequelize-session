# connect middleware session store interface specification
_ = require 'underscore'
aCheck = require './checker'

# attention: stateful test spec, beware of right order
module.exports = (createStore) ->
  sessions =
    sid0: { data: key: 'a session' }
    sid1: { data: key: 'another one' }

  store = createStore sessions

  it 'extends connect.session.Store.prototype', ->
    expect(store.createSession).toBeDefined 'inherits session create method'

  it 'defines get(sid, callback)', =>
    aCheck 'get a session', (done) ->
      store.get 'sid1', (error, session) ->
        expect(error).toBeNull 'no error'
        expect(_.isEqual session, sessions.sid1).toBeTruthy 'session one'
        done()

    aCheck 'get unknown session', (done) ->
      store.get 'sid3', (error, session) ->
        expect(error).toBeDefined 'an error'
        expect(session).toBeUndefined 'no session'
        done()

  it 'defines set(sid, session, callback)', =>
    aCheck 'set session without callback', (done) ->
      store.set 'sid2', { data: key: 'third session' }, done

  it 'defines length(callback)', ->
    aCheck 'get session count', (done) ->
      store.length (count) ->
        expect(count).toBe 3, 'sessions length'
        done()

  it 'defines destroy(sid, callback)', =>
    aCheck 'destroy session one', (done) ->
      store.destroy 'sid1', (error) ->
        expect(error).toBeUndefined 'no error'
        done()

    aCheck 'destroy unknown session', (done) ->
      store.destroy 'sid3', (error) ->
        expect(error).toBeDefined 'an error'
        done()

  it 'defines clear(callback)', ->
    aCheck 'clear store', (done) ->
      store.clear (error) ->
        expect(error).toBeUndefined 'no error'
        done()
