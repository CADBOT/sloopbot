# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot unsafe me <query> - The *modified* Original. Queries Google Images for <query> and returns a random top result.
request = require 'superagent'

numAjaxCalls = 0

module.exports = (robot) ->
  robot.respond /(unsafe|us)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

imageMe = (msg, query, cb) ->
  # Using deprecated Google image search API
  bag = numAjaxCalls: 0
  #['active', 'off'].forEach (setting) -> imageSearch(msg, {v: '1.0', rsz: '8', q: query}, setting, bag)
  #2 + 2 until bag.numAjaxCalls == 2 
  imageSearch(msg, {v: '1.0', rsz: '8', q: query}, 'off', bag, cb)
  imageSearch(msg, {v: '1.0', rsz: '8', q: query}, 'active', bag, cb)

imageSearch = (msg, q, setting, bag, cb) ->
  q.safe = setting
  request
    .get('https://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .end (err, res) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      if res.statusCode isnt 200
        msg.send "Bad HTTP response :( #{res.statusCode}"
        return
      bag[setting] = JSON.parse(res.text).responseData?.results
      bag.numAjaxCalls += 1
      filterOutSafe(bag, msg, cb) if bag.numAjaxCalls == 2

ensureImageExtension = (url) ->
  ext = url.split('.').pop()
  if /(png|jpe?g|gif)/i.test(ext)
    url
  else
    "#{url}#.png"

filterOutSafe = (bag, msg, cb) ->
  safeImageIds = {}
  bag.active.forEach (image) -> safeImageIds[image.imageId] = true
  unsafeImages = bag.off.filter (image) ->
    not safeImageIds[image.imageId]

  image = msg.random(unsafeImages)
  cb(image.unescapedUrl)
