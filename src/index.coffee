# Dependencies
Promise= require 'bluebird'
request= unless window? then require 'request' else require 'xhr'
throat= require 'throat'

# Public
class Caravan
  fetchAll: (urls,options={})->
    options.concurrency?= 1

    concurrency= throat options.concurrency
    promises=
      for url in urls
        do (url)->
          concurrency ->
            new Promise (resolve,reject)->
              request url,(error,response)->
                unless error
                  resolve response
                else
                  reject error

    Promise.settle promises
    .then (results)->
      for result in results
        if result.isFulfilled()
          result.value().body
        else
          result.reason()

module.exports= new Caravan
module.exports.Caravan= Caravan