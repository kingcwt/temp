
_ = require "lodash"
request = require 'request'
os = require "os"
p = require "commander"
env = p.environment

debuglog = require("debug")("geop:utils:mailer")

POSTMARK_APP_KEY = '22b520aa-9507-479f-afce-8eb3ae620465'

REQUEST_URL = "https://api.postmarkapp.com/email"
REQUEST_METHOD = "POST"
REQUEST_HEADERS =
  "Accept": "application/json"
  "Content-Type": "application/json"
  "X-Postmark-Server-Token" : POSTMARK_APP_KEY

#DEFAULT_TO = "2152525@qq.com, yi2004@gmail.com, yuanxiangdong@goyoo.com, tanyi@xiaoyun.com"
DEFAULT_TO = "yuanxiangdong@goyoo.com, tanyi@goyoo.com"

APP_NAME = "UNINITED"

ENV = "unkonw"

MIN_REPORT_DURATION = 5 * 60 * 1000 # 最多5分钟发一次警告邮件

# 最近一次汇报未解析类型的消息
LastReportStrangeMsgsAt = Date.now()

# 最短10分钟汇报一次
MIN_DURATION_OF_REPORT_STRANG_MSG =  10 * 60 * 1000

sendWebsiteContact = (msgBody)->
  debuglog "[sendBotChecker] start. "
  to = "2456567972@qq.com"
  subject = "Msg from #{msgBody.name || ''} at #{new Date}"

  textBody = """
Visitor on website geop.org sent following message:

Date  : #{Date()}

From  : #{msgBody.name || 'unkonwn'}

Email : #{msgBody.email || ''}

Phone : #{msgBody.phone || ''}

Interest : #{msgBody.interest || ''}

Country : #{msgBody.country || ''}

Company Name : #{msgBody.company_name || ''}


Product Name : #{msgBody.product_name || ''}

Message :
#{msgBody.message || ''}


==========================================================
[THIS IS AN AUTO SENT MESSAGE. DO NOT REPLY THIS MESSAGE]
==========================================================
"""

  request
    url : "https://api.postmarkapp.com/email"
    method : "POST"
    headers : REQUEST_HEADERS
    json :
      "From" : "notification@teleme.io"
      "To" : to
      "Subject" : subject
      "TextBody":  textBody

module.exports =
  sendWebsiteContact : sendWebsiteContact


