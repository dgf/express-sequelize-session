_ = require 'lodash'
Sequelize = require 'sequelize'

module.exports = (Store) ->

  # Express Sequelize session store
  class E4Store extends Store

    constructor: (@Session) ->

    clear: (callback) ->
      @Session.sync
        force: true
      .then ->
        callback? null, null
      .catch (err) ->
        callback? err, null

    destroy: (sid, callback) ->
      @Session.destroy
        where: sid: sid
      .then ->
        callback? null, null
      .catch (err) ->
        callback? err, null

    length: (callback) ->
      @Session.count()
      .then (count) ->
        callback? count
      .catch (err) ->
        callback? err

    get: (sid, callback) ->
      @Session.findOne
        where: sid: sid
        attributes: ['data']
      .then (session) ->
        if session?
          callback? null, JSON.parse session.data
        else # not found
          callback? null, null
      .catch (err) ->
        callback? err, null

    set: (sid, session, callback) ->
      data = JSON.stringify session
      @Session.findOne
        where:
          sid: sid
      .then (s) => # yield or build
        if s? then s else @Session.build sid: sid
      .then (s) -> # update session data
        s.data = data
        s.save()
      .then (s) ->
        callback? null, s
      .catch (err) ->
        callback? err, null

  # export factory method
  (sequelize, name = 'Session', model = {}) ->
    new E4Store sequelize.define name, _.extend model,
      sid:
        type: Sequelize.STRING
        allowNull: false
        unique: true
        validate: notEmpty: true
      data:
        type: Sequelize.TEXT
        allowNull: true
