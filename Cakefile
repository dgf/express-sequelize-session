fs = require 'fs'
{print} = require 'util'
{spawn} = require 'child_process'
mocha = './node_modules/mocha/bin/mocha'
lint = './node_modules/coffeelint/bin/coffeelint'
files = 'Cakefile coffeelint.opts coverage.js package.json ./src ./test'

# ANSI Terminal Colors
green = '\x1b[32m'
reset = '\x1b[0m'
red = '\x1b[31m'

log = (message, color) -> console.log color + message + reset

call = (name, options, callback) ->
  proc = spawn name, options.split(' ')
  proc.stdout.on 'data', (data) -> print data.toString()
  proc.stderr.on 'data', (data) -> log data.toString(), red
  proc.on 'exit', callback

# calls a process and redirects the stdout in to a file
callOUT = (file) -> (cmd, options, done) ->
  logFile = fs.openSync file, 'w+', '660'
  proc = spawn cmd, options.split(' '), stdio: ['ignore', logFile]
  proc.stderr.on 'data', (data) -> print data.toString()
  proc.on 'exit', (code, signal) ->
    fs.closeSync logFile
    done code, signal

build = (callback) -> call 'coffee', '-c -o lib src', callback

spec = (callback) -> call mocha, 'test/*.spec.coffee', callback

clint = (callback) -> call lint, '-f coffeelint.opts ' + files, callback

coverage = (callback) ->
  callOUT('coverage.html') mocha, '--require coverage.js --reporter html-cov test/*.spec.coffee', callback

logSuccess = (status) -> log ":)", green if status is 0

task 'build', 'build coffee', -> build logSuccess

task 'coverage', 'run coverage', -> coverage logSuccess

task 'lint', 'run lint', -> clint logSuccess

task 'spec', 'run specifications', -> spec logSuccess
