
if Meteor.isServer
  Meteor.methods
    sendMessage: (from, to, message)->
      messages.insert({from: from, to: to, message: message, time: new Date().getTime()})



  Meteor.publish('userStatus', () ->
    this.ready()
    Meteor.users.find({ "status.online": true })
  )

  Meteor.publish('messages', () ->
    this.ready()
    messages.find({})
  )