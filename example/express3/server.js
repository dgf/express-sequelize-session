require('coffee-script/register');
require('./app')(function (err, app, db) {
  db.User.create({ login: 'admin', password: 'secret' }).done(function () {
    require('http').createServer(app).listen(1337, '127.0.0.1');
  });
});
