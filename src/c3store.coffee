_ = require 'lodash'
Sequelize = require 'sequelize'

module.exports = (Store) ->

  # error wrapper
  checkError = (callback) -> (error) -> if error? then callback? error else callback?()

  # connect middleware session implementation
  class C3Store extends Store

    constructor: (@Session) ->

    clear: (callback) ->
      @Session.sync(force: true).done checkError callback

    destroy: (sid, callback) ->
      @Session.destroy(sid: sid).done checkError callback

    length: (callback) ->
      @Session.count().done (error, count) ->
        if error? then callback? error else
          callback? count

    get: (sid, callback) ->
      options =
        where: sid: sid
        attributes: ['data']
      @Session.find(options).done (error, session) ->
        if error?
          callback? error
        else if session
          callback? null, JSON.parse session.data
        else
          callback?()

    set: (sid, session, callback) ->
      q = sid: sid
      d = data: JSON.stringify session
      @Session.findOrCreate(q, d).done (error, s) ->
        if error?
          callback? error
        else if s.data isnt d.data
          s.updateAttributes(d).done checkError callback
        else
          callback?()

  # return factory method
  (sequelize, name = 'Session', model = {}) ->
    new C3Store sequelize.define name, _.extend model,
      sid:
        type: Sequelize.STRING
        allowNull: false
        unique: true
        validate: notEmpty: true
      data:
        type: Sequelize.TEXT
        allowNull: true
