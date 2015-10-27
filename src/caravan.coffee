# Dependencies
Q= require 'q'
throat= (require 'throat') Q.Promise
superagent= require 'superagent'

merge= require 'merge'

# Private
verbs= [
  'checkout',
  'connect',
  'copy',
  'delete',
  'get',
  'head',
  'lock',
  'merge',
  'mkactivity',
  'mkcol',
  'move',
  'm-search',
  'notify',
  'options',
  'patch',
  'post',
  'propfind',
  'proppatch',
  'purge',
  'put',
  'report',
  'search',
  'subscribe',
  'trace',
  'unlock',
  'unsubscribe',
]

# Public
class Caravan
  constructor: ->
    for verb in verbs
      @[verb]= @verb.bind(this,verb.toUpperCase())

  verb: (verb,urls,options={})=>
    options= JSON.parse JSON.stringify options # keep a origin references
    options.method= verb

    @request urls,options

  request: (urls,options={})=>
    options= JSON.parse JSON.stringify options
    options.concurrency?= 1

    concurrency= throat options.concurrency

    urls= [urls] unless urls instanceof Array
    promises=
      for url in urls
        do (url)=>
          concurrency =>
            @requestAsync url,options

    @settle promises,options

  requestAsync: (url,options={})=>
    options= JSON.parse JSON.stringify options
    options.method?= 'GET'

    if typeof url is 'object'
      options= merge options,url
      url= options.url ? options.uri

    options.delay= (options.delay|0) # normalize

    return Q.reject(new TypeError 'url/uri is not defined') unless url

    new Q.Promise (resolve,reject,notify)=>
      request= superagent options.method,url

      for key,value of options
        key= 'set' if key is 'headers'
        key= 'send' if key is 'data'

        continue unless typeof request[key] is 'function'

        request[key] value

      request.end (error,response)=>
        notify error ? (@getBody response,options)

        setTimeout ->
          unless error
            resolve response
          else
            reject error
          
        ,options.delay

  settle: (promises,options={})=>
    options.raw?= false

    Q.allSettled promises
    .then (results)=>
      for result in results
        if result.state is 'fulfilled'
          @getBody result.value,options

        else
          result.reason

  getBody: (response,options={})=>
    hasKeys= (Object.keys response.body).length > 0

    switch
      when options.raw
        response

      when hasKeys
        response.body

      else
        response.text

module.exports= new Caravan
module.exports.Caravan= Caravan
