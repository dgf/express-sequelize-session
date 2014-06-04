require('coffee-coverage').register({
  path: 'relative',
  basePath: require('path').join(__dirname, 'src'),
  initAll: true,
  streamlinejs: false
})
