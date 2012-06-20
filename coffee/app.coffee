express = require 'express'
fapi = new require(process.env.FAPI_ROOT || './fapi')

app = express.createServer(express.logger())

# CORS middleware
config =
  allowedDomains: '*'

allowCrossDomain = (req, res, next) ->
    res.header('Access-Control-Allow-Origin', config.allowedDomains)
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST')
    res.header('Access-Control-Allow-Headers', 'Content-Type')
    next()

app.configure ->
    app.use express.bodyParser()
    app.use express.cookieParser()
    app.use express.methodOverride()
    app.use allowCrossDomain
    app.use app.router

FAPI_FILES_ROOT = 'fake_plugins'



app.get /^\/fapi\/(.*)/, (req, res) ->
  new fapi.Fapi(FAPI_FILES_ROOT).get req, res, req.params[0]

app.post /^\/fapi\/(.*)/, (req, res) ->
  new fapi.Fapi(FAPI_FILES_ROOT).post req, res, req.params[0]

app.get '/fapi', (req, res) ->
  res.redirect '/fapi/'

# Startup the server
port = process.env.PORT || 3000
app.listen port, ->
  console.log "Listening on #{port}"
