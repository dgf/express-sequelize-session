Sequelize = require 'sequelize'
crudl = require 'crudl-model'
_ = require 'underscore'

SessionModel =
  sid:
    type: Sequelize.STRING
    allowNull: false
    unique: true
    validate: notEmpty: true
  data:
    type: Sequelize.TEXT
    allowNull: false
    validate: notEmpty: true

# connect middleware session implementation
class C3Store

  constructor: (@SequelizeSession) ->
    @Session = crudl @SequelizeSession

  clear: (callback) ->
    success = -> callback?()
    error = (error) -> callback? error
    @Session.clear success, error

  destroy: (sid, callback) ->
    success = -> callback?()
    error = (error) -> callback? error
    q = where: sid: sid
    @Session.delete q, success, error

  length: (callback) ->
    success = (count) -> callback? count
    error = (error) -> callback? null
    @Session.count success, error

  get: (sid, callback) ->
    success = (session) ->
      if session
        callback? null, JSON.parse session.data
      else
        callback? 'session not found'
    error = (error) -> callback? error

    q = where: sid: sid
    @Session.find q, success, error

  set: (sid, session, callback) ->
    s = sid: sid, data: JSON.stringify session
    success = (session) -> callback?()
    error = (error) -> callback? error
    @Session.create s, success, error

module.exports = (connect) ->
  C3Store:: __proto__ = connect.session.Store.prototype
  (sequelize, model) -> new C3Store sequelize.define 'Session', _.extend(SessionModel, model)
