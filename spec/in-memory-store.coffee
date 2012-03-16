SID_PATTERN = /sid(\d)/

ifSidMatches = (sid, error, success) -> # error hook base
  if not SID_PATTERN.test sid
    error? 'invalid sid format'
  else
    success()

class InMemorySessionStore

  constructor: (options) ->
    @sessions = []
    @getBySid = (sid) -> @sessions[parseInt sid.match(SID_PATTERN)[1]]

  clear: (callback) ->
    if @sessions?
      @sessions = []
      callback()
    else
      callback 'clear call failed'

  destroy: (sid, callback) ->
    ifSidMatches sid, callback, =>
      session = @getBySid(sid)
      if session?
        delete session
        callback?()
      else
        callback? 'session not found'

  length: (callback) ->
    if @sessions? then callback @sessions.length else callback null

  get: (sid, callback) ->
    ifSidMatches sid, callback, =>
      session = @getBySid(sid)
      if session?
        callback null, session # return data
      else
        callback 'nothing found'

  set: (sid, session, callback) ->
    ifSidMatches sid, callback, =>
      @sessions.push session
      callback?()


module.exports = (connect) ->
  InMemorySessionStore:: __proto__ = connect.session.Store.prototype
  InMemorySessionStore
