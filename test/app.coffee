# Dependencies
express= require 'express'

# Environment
PORT= 8888

# Setup express
app= express()

# Disable CORS
app.use (req,res,next)->
  res.setHeader 'Access-Control-Allow-Origin','*'
  res.setHeader 'Access-Control-Allow-Headers','X-Requested-With'
  res.setHeader 'Access-Control-Allow-Headers','Content-Type'
  res.setHeader 'Access-Control-Allow-Methods','PUT, GET, POST, DELETE, OPTIONS'
  next()

# Routes
app.get '/:str',(req,res)->
  setTimeout ->
    res.end req.params.str
  ,500
app.get '/ping/:sec(\\d+)s',(req,res)->
  msec= Number(req.params.sec)*1000

  setTimeout (-> res.end()),msec
app.use (req,res)->
  res.status(500).send 'notfound'

# Boot
app.listen PORT unless module.parent?

module.exports= app