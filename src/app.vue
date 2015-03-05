<style lang="stylus">
  #app
    height 100vh

  #chatbox
    height 100%

  #contactsbox
    height 100%
</style>

<template lang="jade">
div(id="chatbox", v-component="{{chatView}}", v-with="api: jslineApi, client: client, chatting: chatting, polledMessage: polled, clickedChat: clickedChat, notification: notification", class="col-md-8 col-sm-8 col-xs-8", keep-alive, v-transition)
div(id="contactsbox", v-component="contacts-view", class="col-md-4 col-sm-4 col-xs-4", keep-alive, v-transition)
</template>

<script lang="coffee">
gui = require 'nw.gui'
win = gui.Window.get()

module.exports =
  el: ->
    '#app'
  data: ->
    jslineApi: require 'jsline-api'
    client: null
    chatView: ''
    contactView: ''
    logined: null
    chatting: []
    polled: []
    notification: []
    clickedChat: null
    nwCookies: win.cookies
  watch:
    'client': 'startLongPoll'
  methods:
    startLongPoll: () ->
      if localStorage.getItem('authToken') and @client
        OT = @client.config.OT
        TalkException = @client.config.TalkException
        setInterval(
          Promise.coroutine(
            () =>
              try
                # console.log 'Start Polling...'
                operations = yield @client._fetchOperations @client.revision
                for operation in operations
                  switch operation.type
                    when OT.END_OF_OPERATION then continue
                    when OT.SEND_MESSAGE, OT.RECEIVE_MESSAGE
                      message = new @jslineApi.LineMessage @client, operation.message

                      raw_sender = operation.message.from
                      raw_receiver = operation.message.to

                      sender = @client.getContactOrRoomOrGroupById raw_sender
                      receiver = @client.getContactOrRoomOrGroupById raw_receiver

                      if not sender and typeof receiver is @jslineApi.LineGroup
                        for member in receiver.members
                          if member.id is raw_sender
                            sender = member

                      if not sender or not receiver
                        @client.refreshGroups()
                        @client.refreshContacts()
                        @client.refreshActiveRooms()
                        sender = @client.getContactOrRoomOrGroupById raw_sender
                        receiver = @client.getContactOrRoomOrGroupById raw_receiver

                      checkPolled = _.flatten @polled, true
                      idx = _.findIndex checkPolled, (value) =>
                        if value instanceof @jslineApi.LineMessage
                          value.id is message.id
                        else
                          return false;
                      if idx is -1
                        @polled.push [sender, receiver, message]
                      # yield [sender, receiver, message]
                    else
                      console.log "[*] #{operation.type}"
                      console.dir operation
                  @client.revision = Math.max operation.revision, @client.revision
              catch err
                console.dir err
          )
        , 1000)
  compiled: ->
    account = localStorage.getItem 'account'
    password = localStorage.getItem 'password'
    authToken = localStorage.getItem 'authToken'
    certificate = localStorage.getItem 'certificate'
    if authToken && certificate && account && password
      @client = new @jslineApi.LineClient account, password, authToken, certificate
      @client.login().then (result) =>
        @logined = !!result
        if @logined
          @contactView = 'contacts-list-view'
  components:
    # Used by left panel
    'logo-view': require './views/logo-view.vue'
    'user-chat-view': require './views/user-chat-view.vue'
    # Used by right panel
    'login-view': require './views/login-view.vue'
    'contacts-view': require './views/contacts-view.vue'
</script>
