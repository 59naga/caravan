# Dependencies
Promise= require 'bluebird'
throat= require 'throat'
superagent= require 'superagent'

objectAssign= require 'object-assign'

# Private
verbs= [
  'checkout'
  'connect'
  'copy'
  'delete'
  'get'
  'head'
  'lock'
  'merge'
  'mkactivity'
  'mkcol'
  'move'
  'm-search'
  'notify'
  'options'
  'patch'
  'post'
  'propfind'
  'proppatch'
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
      options= objectAssign options,url
      url= options.url ? options.uri

    return Promise.reject(new TypeError 'url/uri is not defined') unless url

    new Promise (resolve,reject)->
      request= superagent options.method,url

      for key,value of options
        key= 'set' if key is 'headers'
        key= 'send' if key is 'data'

        continue unless typeof request[key] is 'function'

        request[key] value

      request.end (error,response)->
        unless error
          resolve response
        else
          reject error

  settle: (promises,options={})=>
    options.raw?= false

    Promise.settle promises
    .then (results)->
      for result in results
        if result.isRejected()
          result.reason()

        else
          value= result.value()
          hasKeys= (Object.keys value.body).length > 0

          switch
            when options.raw
              value

            when hasKeys
              value.body

            else
              value.text

module.exports= new Caravan
module.exports.Caravan= Caravan
