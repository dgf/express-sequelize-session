# connect express Sequelize session store implementation

```coffeescript
express = require 'express'
C3Store = require('c3store') express

sequelize = new Sequelize 'db.name', 'db.user', 'db.pass'

app = express.createServer()
...
app.configure 'production', ->
  ...
  app.use express.session
    secret: "MyAwesomeAppSessionSecret",
    store: new C3Store sequelize
```

[![Build Status](https://travis-ci.org/dgf/c3store.png)](https://travis-ci.org/dgf/c3store/)
