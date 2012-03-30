# connect express Sequelize session store implementation

    express = require 'express'
    C3Store = require('c3store') express

    sequelize = new Sequelize 'db.name', 'db.user', 'db.pass'
    sessionStore = new C3Store sequelize

    app = express.createServer()
    ...
    app.configure 'production', ->
      ...
      app.use express.session
        secret: "MyAwesomeAppSessionSecret",
        store: sessionStore
