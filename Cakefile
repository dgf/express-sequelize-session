{print} = require 'util'
{spawn} = require 'child_process'
mocha = './node_modules/mocha/bin/mocha'
lint = './node_modules/coffeelint/bin/coffeelint'

# ANSI Terminal Colors
green = '\x1b[32m'
reset = '\x1b[0m'
red = '\x1b[31m'

log = (message, color) -> console.log color + message + reset

call = (name, options, callback) ->
  proc = spawn name, options
  proc.stdout.on 'data', (data) -> print data.toString()
  proc.stderr.on 'data', (data) -> log data.toString(), red
  proc.on 'exit', callback

build = (callback) -> call 'coffee', ['-c', '-o', 'lib', 'src'], callback

spec = (callback) -> call mocha, ['test/*.spec.coffee'], callback

clint = (callback) -> call lint, ['-f', 'coffeelint.opts', './src', './test', 'Cakefile'], callback

logSuccess = (status) -> log ":)", green if status is 0

task 'build', 'build coffee', -> build logSuccess

task 'lint', 'run coffee lint', -> clint logSuccess

task 'spec', 'run specifications', -> spec logSuccess
