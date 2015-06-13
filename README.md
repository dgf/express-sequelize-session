# Express Sequelize session store

[![Build Status](https://travis-ci.org/dgf/e4store.png)](https://travis-ci.org/dgf/e4store/)

## Usage

### Express 3.x

```coffeescript

    # load and init express app
    express = require 'express'
    app = express()

    # load and init Sequelize connection
    Sequelize = require 'sequelize'
    sequelize = new Sequelize 'db.name', 'db.user', 'db.pass'

    # load and create session store
    E4Store = require('e4store') express.session.Store
    app.use express.session
      key: 'sid'
      secret: 'MyAwesomeAppSessionSecret'
      store: new E4Store sequelize
```

The [Express 3.x sample application](https://github.com/dgf/e4store-express3-itest/blob/master/src/app.coffee)
shows a complete setup to get started.

### Express 4.x

```coffeescript

    # load and init express app
    express = require 'express'
    expressSession = require 'express-session'
    app = express()

    # load and init Sequelize connection
    Sequelize = require 'sequelize'
    sequelize = new Sequelize 'db.name', 'db.user', 'db.pass'

    # load and create session store
    E4Store = require('e4store') expressSession.Store
    app.use expressSession
      name: 'sid'
      secret: 'MyAwesomeAppSessionSecret'
      store: new E4Store sequelize
      resave: false
      saveUninitialized: true
```

The [Express 4.x sample application](https://github.com/dgf/e4store-express4-itest/blob/master/src/app.coffee)
shows a complete setup to get started.

### Custom Schema

use individual table name with optional string column

```coffeescript

    store = new E4Store sequelize, 'http_session_table',
      optional:
        type: Sequelize.STRING
        allowNull: true
```

reference other entities

```coffeescript

    # define user table
    User = sequelize.define 'user',
      login:
        type: Sequelize.STRING
        allowNull: false
        unique: true
      password:
        type: Sequelize.STRING
        allowNull: false

    # associate session user
    User.belongsTo store.Session, foreignKeyConstraint: true
```

## Development

build and test it

```sh

    e4store git:(master) ✗ cake
    Cakefile defines the following tasks:

    cake build                # build coffee
    cake coverage             # run coverage
    cake lint                 # run lint
    cake spec                 # run specifications
```
