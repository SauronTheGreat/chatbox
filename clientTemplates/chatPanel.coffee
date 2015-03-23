if Meteor.isClient

  #Add css file in client/lib/css -> jquery.ui.chatbox.css
  #Add two packages mizzao:user-status, brentjanderson:buzz
  #Template chatBox is called in main-admin-container div admin panel inside template adminPanel
  #add a collection messages in lib/collections.coffee -> @messages = new Meteor.Collection("messages")
  #Add sounds folder in public
  #Add following line to server/publisher.coffee
  ###########################################################################
  #Meteor.publish('userStatus', () ->
  #  this.ready()
  #  Meteor.users.find({ "status.online": true })
  #)
  #
  #Meteor.publish('messages', () ->
  #  this.ready()
  #  messages.find({})
  #)
  ############################################################################


  #Add sendMessage function in server.coffee code is
  ############################################################################
  #sendMessage: (from, to, message)->
  #  messages.insert({from: from, to: to, message: message, time: new Date().getTime()})
  #
  ############################################################################

  #Add subscription in client/router/router.coffee
  #Meteor.subscribe('messages')

  Template.chatBox.helpers
    userList: ()->
      Meteor.users.find({_id:{$ne:Meteor.userId()}}).fetch()

  Template.chatBoxOld.helpers
    myMessages: (userId)->
      mymessages = []
      m = messages.find({$or:[{$and:[{from:Meteor.userId()},{to:userId}]},{$and:[{to:Meteor.userId()},{from:userId}]}]}).fetch()
      for i in m
        if i.from is Meteor.userId()
          mymessages.push({message: i.message, time: i.time, myClass: "self"})
        else
          mymessages.push({message: i.message, time: i.time, myClass: "other"})
      mymessages

    countTime: (datetime)->
      now = (new Date()).getTime()
      if isNaN(datetime)
        return ''
      if datetime < now
        milisec_diff = now - datetime
      else
        milisec_diff = datetime - now
      days = Math.floor(milisec_diff / 1000 / 60 / 60 / 24)
      date_diff = new Date(milisec_diff)
      if days > 0
        days + ' days ago'
      else if date_diff.getHours() - 5 > 0
        date_diff.getHours() - 5 + ' hours ago'
      else if date_diff.getMinutes() - 30 > 0
        date_diff.getMinutes() - 30 + ' minutes ago'
      else
        'few seconds ago'



  Template.chatBox.labelClass = ()->
    if @status.idle
      'label-warning'
    else if @status.online
      'label-success'
    else
      'label-default'



  Template.chatBox.rendered = ->
    Meteor.subscribe('messages')
    count = 0;
    query = messages.find({to:Meteor.userId()})

    handle = query.observeChanges(
      added: (id, message) ->

        if(new Date().getTime()-message.time < 100)
          s = new buzz.sound('/packages/rushabhhathi_chatbox/libFiles/sounds/beep.mp3');
          s.play()
          user = Meteor.users.findOne({_id:message.from})
          if user
            if($("#theChatBox"+user._id).length < 1)
              Blaze.renderWithData(Template.chatBoxOld,{userName: user.personal_profile.display_name, userId: user._id},document.getElementById('main-admin-container'))
            $('#popup-messages-' + user._id).animate { scrollTop: $('#popup-messages-' + user._id).get(0).scrollHeight }, 'slow', ->
        return
      removed: ->
        count--
        console.log 'Lost one. We\'re now down to ' + count + ' admins.'
        return
    )

  Template.chatBoxOld.events
    'click .send-message': (e) ->
      from = Meteor.userId()
      to = $(e.currentTarget).prev().val()
      msg = $(e.currentTarget).parents('.sendMessage').find('textarea').val()
      Meteor.call("sendMessage", from, to, msg)
      $(e.currentTarget).parents('.sendMessage').find('textarea').val('')
      setTimeout(()->
        $('#popup-messages-' + to).animate { scrollTop: $('#popup-messages-' + to).get(0).scrollHeight }, 'slow', ->
      , 500)


    'keydown textarea' : (e) ->
      if e.which is 13
        from = Meteor.userId()
        to = $(e.currentTarget).parents('.sendMessage').find('.hiddenUser').val()
        msg = $(e.currentTarget).val()
        Meteor.call("sendMessage", from, to, msg)
        $(e.currentTarget).val('')
        $('#popup-messages-' + to).animate { scrollTop: $('#popup-messages-' + to).get(0).scrollHeight }, 'slow', ->


    'click .popup-head-right':(e)->
      $(e.currentTarget).parents('.popup-box').empty().remove();

  Template.chatBox.events
    'click .sidebar-name':(e)->
      Blaze.renderWithData(Template.chatBoxOld,{userName: this.personal_profile.display_name, userId: this._id},document.getElementById('main-admin-container'))
      $('#popup-messages-' + this._id).animate { scrollTop: $('#popup-messages-' + this._id).get(0).scrollHeight }, 'slow', ->

    'click .ui-chatbox-titlebar':(e)->
      if($(e.currentTarget).hasClass('minified'))
        $('.ui-chatbox-content').show();
        $(e.currentTarget).removeClass('minified');
      else
        $('.ui-chatbox-content').hide();
        $(e.currentTarget).addClass('minified');



