# Dependencies
caravan= require '../src'
app= require './app'

# Environment
jasmine.DEFAULT_TIMEOUT_INTERVAL= 10000
PORT= 8888

# Specs
describe 'caravan',->
  server= null
  beforeEach (done)->
    unless window?
      server= app.listen PORT,done
    else
      done()

  afterEach (done)->
    unless window?
      server.close done
    else
      done()

  it '.fetchAll',(done)->
    urls= [
      'http://localhost:'+PORT+'/foo'
      'http://localhost:'+PORT+'/bar'
      'http://localhost:'+PORT+'/baz'
      'http://localhost:'+PORT+'/beep'
      'http://localhost:'+PORT+'/boop'
    ]

    caravan.fetchAll urls,{concurrency:5}
    .then (results)->
      expect(results.join(',')).toBe 'foo,bar,baz,beep,boop'
      done()
      