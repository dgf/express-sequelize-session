{expect} = require 'chai'
Sequelize = require 'sequelize'

describe 'Sequelize Promise API', ->

  sequelize = new Sequelize 'session', 'sa', 'secret',
    dialect: 'sqlite'
    logging: false

  Term = sequelize.define 'Term',
    name:
      type: Sequelize.STRING
      allowNull: false
      unique: true
      validate: notEmpty: true
    desc:
      type: Sequelize.TEXT
      allowNull: true

  invalidTerm = Term.build
    name: null
    desc: 'invalid name'
  validTerm = Term.build
    name: 'a term'
    desc: 'valid term'

  it 'syncs a valid model', (done) ->
    Term.sync
      force: true
    .then (model) ->
      expect(model.name).to.be.equal 'Term'
      done null
    .catch (err) ->
      done err

  it 'promises an error when an invalid instance is to be saved', (done) ->
    invalidTerm.save()
    .then (instance) ->
      done new Error 'invalid instance created'
    .catch (err) ->
      expect(err).to.be.instanceof Error
      expect(err.name).to.be.equal 'SequelizeValidationError'
      expect(err.message).to.have.string 'notNull'
      done null

  it 'promises an instance object when a valid instance is to be saved', (done) ->
    validTerm.save()
    .then (instance) ->
      expect(instance).to.be.instanceof Object
      done null
    .catch (err) ->
      done err

  it 'counts instances', (done) ->
    Term.count()
    .then (count) ->
      expect(count).to.be.equal 1
      done null
    .catch (err) ->
      done err

  it 'finds one instance and promises filtered attributes', (done) ->
    Term.findOne
      where: name: validTerm.name
      attributes: ['desc']
    .then (term) ->
      expect(term.id).to.be.undefined
      expect(term.name).to.be.undefined
      expect(term.desc).to.be.equal validTerm.desc
      done null
    .catch (err) ->
      done err

  it 'finds all instances and promises filtered attributes', (done) ->
    Term.findAll
      where: name: validTerm.name
      attributes: ['desc']
    .then (terms) ->
      expect(terms).to.be.instanceof Array
      expect(terms.length).to.be.equal 1
      term = terms.pop()
      expect(term.id).to.be.undefined
      expect(term.name).to.be.undefined
      expect(term.desc).to.be.equal validTerm.desc
      done null
    .catch (err) ->
      done err

  it 'destoys an existing instance', (done) ->
    Term.destroy
      where: name: validTerm.name
    .then ->
      done null
    .catch (err) ->
      done err

  it 'not fails when a non existing instance is to be destroyed', (done) ->
    Term.destroy
      where: name: validTerm.name
    .then ->
      done null
    .catch (err) ->
      done err

  it 'creates an instance depending on attribute values', (done) ->
    Term.findOrCreate
      where:
        name: validTerm.name
      defaults:
        desc: validTerm.desc
    .spread (term, isCreated) ->
      expect(isCreated).to.be.true
      expect(term.id).to.be.defined
      expect(term.name).to.be.equal validTerm.name
      expect(term.desc).to.be.equal validTerm.desc
      done null
    .catch (err) ->
      done err

  it 'finds an instance depending on attribute values', (done) ->
    Term.findOrCreate
      where:
        name: validTerm.name
      defaults:
        desc: 'ignored value'
    .spread (term, isCreated) ->
      expect(isCreated).to.be.false
      expect(term.id).to.be.defined
      expect(term.name).to.be.equal validTerm.name
      expect(term.desc).to.be.equal validTerm.desc
      done null
    .catch (err) ->
      done err

  it 'updates values of exiting instances', (done) ->
    values = desc: 'new description'
    options =
      where:
        name: validTerm.name
    Term.update(values, options)
    .spread (count) ->
      expect(count).to.be.equal 1
      done null
    .catch (err) ->
      done err

  it 'updates values of an instance', (done) ->
    values = desc: 'updated description'
    Term.find
      where:
        name: validTerm.name
    .then (term) ->
      term.update values
    .then (updatedTerm) ->
      expect(updatedTerm.id).to.be.defined
      expect(updatedTerm.name).to.be.equal validTerm.name
      expect(updatedTerm.desc).to.be.equal values.desc
      done null
    .catch (err) ->
      done err

  it 'upserts values', (done) ->
    values =
      name: validTerm.name
      desc: 'upserted description'
    Term.upsert(values)
    .then ->
      done null
    .catch (err) ->
      done err
