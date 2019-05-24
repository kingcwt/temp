
_ = require 'lodash'
debuglog = require('debug')("geop:controllers:contact")
bodyParser = require 'body-parser'
express = require "express"
{sendWebsiteContact} = require "../utils/mailer"

UrlencodedParser = bodyParser.urlencoded
  extended: false
  limit : '4kb'
  parameterLimit : 6

postContact = (req, res, next)->
  debuglog "[postContact] req.body:", req.body
  sendWebsiteContact(req.body)
  res.send "OK"
  return


router = express.Router()

# 客户端请求修改 chat timezone
router.post '/',
  UrlencodedParser,
  postContact

module.exports = exports = router

