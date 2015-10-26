# Dependencies
caravan= require '../src'

# Environment
jasmine.DEFAULT_TIMEOUT_INTERVAL= 10000

# Specs
describe 'caravan',->
  describe 'default GET',->
    it 'single',(done)->
      urls= 'http://superserver.berabou.me/foo' # See also 59naga/superserver
      options= {}

      caravan urls,options
      .then ([request])->
        expect(request.method).toBe 'GET'
        expect(request.url).toBe '/foo'
        expect(request.data).toBe undefined
        done()

    it 'multiple',(done)->
      urls= [
        'http://superserver.berabou.me/foo'
        'http://superserver.berabou.me/bar'
        'http://superserver.berabou.me/baz'
        'http://superserver.berabou.me/beep'
        'http://superserver.berabou.me/boop'
      ]
      options=
        concurrency: 5

      caravan urls,options
      .then (responses)->
        expect(responses[0].url).toBe '/foo'
        expect(responses[1].url).toBe '/bar'
        expect(responses[2].url).toBe '/baz'
        expect(responses[3].url).toBe '/beep'
        expect(responses[4].url).toBe '/boop'

        done()

    describe 'options',->
      it '{raw:true}',(done)->
        caravan 'http://superserver.berabou.me/foo',{raw:yes}
        .then ([response])->
          expect(response.status).toBe 200

          request= response.body
          expect(request.method).toBe 'GET'
          expect(request.url).toBe '/foo'
          expect(request.data).toBe undefined

          done()

      it 'otherwise pass to superagent',(done)->
        urls= 'http://superserver.berabou.me/'
        options=
          headers: {foo:'bar'}
          send: {baz:'beep'}

        caravan urls,options
        .then ([request])->
          expect(request.method).toBe 'GET'
          expect(request.headers.foo).toBe 'bar'
          expect(request.data.baz).toBe 'beep'

          done()

  describe 'other verbs',->
    it 'PATCH,GET,POST,PUT,DELETE',(done)->
      urls= [
        {url:'http://superserver.berabou.me/'}
        {url:'http://superserver.berabou.me/',method:'GET'}
        {url:'http://superserver.berabou.me/',method:'POST'}
        {url:'http://superserver.berabou.me/',method:'PUT'}
        {url:'http://superserver.berabou.me/',method:'DELETE'}
        {url:'http://superserver.berabou.me/'}
      ]
      options=
        method: 'PATCH'
        concurrency: 5

      caravan urls,options
      .then (responses)->
        expect(responses[0].method).toBe 'PATCH'
        expect(responses[1].method).toBe 'GET'
        expect(responses[2].method).toBe 'POST'
        expect(responses[3].method).toBe 'PUT'
        expect(responses[4].method).toBe 'DELETE'
        expect(responses[5].method).toBe 'PATCH'

        done()
