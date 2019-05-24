
_ = require 'lodash'
debuglog = require('debug')("tgb:telemio")

p = require "commander"
fs = require 'fs'
Url = require 'url'
path = require 'path'
express = require('express')
crypto = require "crypto"
bodyParser = require 'body-parser'

pkg = require "../package.json"
p.version(pkg.version)
 .option('-e, --environment [type]', 'runtime environment of [development, production, testing]', 'development')
 .option('-p, --port [value]')
 .parse(process.argv)

rootPath = path.resolve(__dirname, "../")

env = p.environment
#process.env.NODE_ENV = env


UrlencodedParser = bodyParser.urlencoded
  extended: false
  limit : '100kb'
  parameterLimit : 100

HTTP_PORT = parseInt(p.port) || 7799

startWebServer = ->
  #console.dir I18N_ENTRIES
  debuglog "[startWebServer]"

  ######################################
  # create web server instance
  ######################################
  app = express()
  app.use(express.static(path.join(rootPath, "/"), {maxAge:864000000}))
  app.disable('x-powered-by')
  app.set 'views', path.join(rootPath, '/')
  app.set 'view engine', 'html'
  app.set 'view options', {pretty:true}

  app.use(bodyParser({limit: '50mb'}))
  app.use(bodyParser.urlencoded({ extended: false }))  #extend:false post请求内容value值只能为str或arr
  app.use(bodyParser.json())

  app.get '/', (req, res)-> res.render "index"
  app.use('/contact', require('./controllers/contact'))
 

  ######################################
  # start web server
  ######################################
  app.listen(HTTP_PORT)
  console.log "**************************************************************************"
  console.log "***      #{pkg.name} VER:#{pkg.version} PORT:#{HTTP_PORT} ***"
  console.log "**************************************************************************"

  return

startWebServer()


