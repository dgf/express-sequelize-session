SID_PATTERN = /sid(\d)/

ifSidMatches = (sid, error, success) -> # error hook base
  if not SID_PATTERN.test sid
    error? 'invalid sid format'
  else
    success()

module.exports = (Store) ->

  class InMemorySessionStore extends Store

    constructor: ->
      @sessions = []
      @getSidPosition = (sid) -> parseInt sid.match(SID_PATTERN)[1]
      @getBySid = (sid) => @sessions[@getSidPosition sid]

    clear: (callback) ->
      if @sessions?
        @sessions = []
        callback?()
      else
        callback? 'clear call failed'

    destroy: (sid, callback) ->
      ifSidMatches sid, callback, =>
        if @getBySid(sid)? then delete @sessions[@getSidPosition sid]
        callback?()

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
        pos = @getSidPosition sid
        if @sessions[pos]?
          @sessions[pos] = session
        else
          @sessions.push session
        callback?()
