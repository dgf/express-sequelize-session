{print} = require 'util'
{spawn} = require 'child_process'
jasmineBinary = './node_modules/jasmine-node/bin/jasmine-node'

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

spec = (callback) -> call jasmineBinary, ['spec', '--verbose', '--coffee'], callback

logSuccess = (status) -> log ":)", green if status is 0

task 'build', 'build coffee', -> build logSuccess

task 'spec', 'run specifications', -> spec logSuccess
