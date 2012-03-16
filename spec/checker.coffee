module.exports = (message, test, timeout = 20) ->
  isDone = false
  runs -> test -> isDone = true
  waitsFor (-> isDone), message, timeout
