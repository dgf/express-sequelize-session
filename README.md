# connect express Sequelize session store implementation

[![Build Status](https://travis-ci.org/dgf/c3store.png)](https://travis-ci.org/dgf/c3store/)

## Usage

typical usage scenario with express 3.x

```coffeescript
# load and init express app
express = require 'express'
app = express()

# load and init Sequelize connection
Sequelize = require 'sequelize'
sequelize = new Sequelize 'db.name', 'db.user', 'db.pass'

# load and create session store
C3Store = require('c3store') express.session.Store
app.use express.session
  secret: 'MyAwesomeAppSessionSecret'
  store: new C3Store sequelize
```

change table name and define additional attributes

```coffeescript
store = new C3Store db, 'http_session_table',
  optional:
    type: Sequelize.STRING
    allowNull: true
```

## Development

build and test it

```sh
c3store git:(master) ✗ cake
Cakefile defines the following tasks:

cake build                # build coffee
cake coverage             # run coverage
cake lint                 # run lint
cake spec                 # run specifications
```
