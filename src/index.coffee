path = require 'path'
express = require 'express'

app = express()
app.use express.bodyParser()

assetPath = path.resolve __dirname + '/../assets'
app.use '/_assets', express.static(assetPath)

app.get '/favicon.ico', (request, response) ->
  response.end()

rootPath = path.resolve "#{__dirname}/../public"

get = require './get'
app.get '*', (request, response) ->
  get rootPath, request.path, request.query, (html) ->
    response.send(html)


post = require './post'
app.post '*', (request, response) ->
  post rootPath, request.path, request.body, request.query, request.url, (url) ->
    response.redirect url


server = app.listen 8080, ->
  port = server.address().port
  console.log "Listening on port: #{port}"

