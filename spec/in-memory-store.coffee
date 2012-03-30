SID_PATTERN = /sid(\d)/

ifSidMatches = (sid, error, success) -> # error hook base
  if not SID_PATTERN.test sid
    error? 'invalid sid format'
  else
    success()

class InMemorySessionStore

  constructor: (options) ->
    @sessions = []
    @getSidPosition = (sid) -> parseInt sid.match(SID_PATTERN)[1]
    @getBySid = (sid) => @sessions[@getSidPosition sid]

  clear: (callback) ->
    if @sessions?
      @sessions = []
      callback()
    else
      callback 'clear call failed'

  destroy: (sid, callback) ->
    ifSidMatches sid, callback, =>
      session = @getBySid sid
      if session?
        delete @sessions[@getSidPosition sid]
        callback?()
      else
        callback? 'session not found'

  length: (callback) ->
    if @sessions? then callback @sessions.length else callback null

  get: (sid, callback) ->
    ifSidMatches sid, callback, =>
      session = @getBySid sid
      if session?
        callback null, session # return data
      else
        callback()

  set: (sid, session, callback) ->
    ifSidMatches sid, callback, =>
      @sessions.push session
      callback?()


module.exports = (connect) ->
  InMemorySessionStore:: __proto__ = connect.session.Store.prototype
  InMemorySessionStore
