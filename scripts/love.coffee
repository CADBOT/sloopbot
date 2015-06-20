module.exports = (robot) ->
  robot.hear /I love you Hubot/i, (msg) ->
    msg.send 'I love you too!'
