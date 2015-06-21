module.exports = (robot) ->
  robot.hear /bojack/i, (msg) ->
    user = msg.message.user.name
    robot.brain[user] = robot.brain[user] + 1 || 1
    msg.send "#{user}'s bojack count: #{robot.brain[user]}"
