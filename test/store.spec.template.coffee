# connect middleware session store interface specification
{expect} = require 'chai'

# attention: stateful test spec, beware of right order
module.exports = (createStore) ->

  sessions =
    sid0: { data: key: 'a session' }
    sid1: { data: key: 'another one' }

  store = createStore sessions

  it 'extends connect.session.Store.prototype', ->
    expect(store.createSession).to.exist

  it 'defines get(sid, callback)', (done) ->
    store.get 'sid1', (error, session) ->
      expect(error).to.be.null
      expect(session).to.deep.equal sessions.sid1, 'session one'
      done()

  it 'returns nothing for unknown sid', (done) ->
    store.get 'sid3', (error, session) ->
      expect(error).to.be.undefined
      expect(session).to.be.undefined
      done()

  it 'defines set(sid, session, callback)', (done) ->
    session = data: key: 'third session'
    store.set 'sid2', session, (error) ->
      expect(error).to.be.undefined
      store.get 'sid2', (error, actual) ->
        expect(error).to.be.null
        expect(actual.data.key).to.equal session.data.key, 'third session'
        done()

  it 'set(sid, session, callback) can be called twice', (done) ->
    session = data: key: 'updated third session'
    store.set 'sid2', session, (error) ->
      expect(error).to.be.undefined
      store.get 'sid2', (error, actual) ->
        expect(error).to.be.null
        expect(actual.data).to.deep.equal session.data, 'updated session'
        done()

  it 'defines length(callback)', (done) ->
    store.length (count) ->
      expect(count).to.equal 3, 'sessions length'
      done()

  it 'defines destroy(sid, callback)', (done) ->
    store.destroy 'sid1', (error) ->
      expect(error).to.be.undefined
      done()

  it 'not destroys unknown sessions', (done) ->
    store.destroy 'sid3', (error) ->
      expect(error).to.be.undefined
      done()

  it 'defines clear(callback)', (done) ->
    store.clear (error) ->
      expect(error).to.be.undefined
      done()
