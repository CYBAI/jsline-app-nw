<style lang="stylus">
.jsline-chat-tab-content
  overflow-x hidden
  overflow-y auto
  padding-right 1px
  padding-left 1px
  margin-right auto
  margin-left auto

@media (min-height: 516px)
  .jsline-chat-tab-content
    height 65vh
@media (min-height: 660px)
  .jsline-chat-tab-content
    height 72vh
@media (min-height: 790px)
  .jsline-chat-tab-content
    height 82vh
.form-control
  float left !important
</style>

<template lang="jade">
div(v-component="tab-view")
div.input-group
  textarea(class="form-control", v-model="message", rows="3", v-on="keyup: submit | key enter")
  span(class="input-group-addon btn btn-primary", v-on="click: submit") Send
</template>

<script lang="coffee">
stripBom = require 'strip-bom'
module.exports =
  el: ->
    '#chatbox'
  data: ->
    polledIdx: 0
    tabs: []
    messages: []
    contentView: 'chat-messages'
    tabContentClass: 'jsline-chat-tab-content'
  watch:
    'clickedChat': 'changeContent'
    'polledMessage': 'changeMessages'
  compiled: ->
    for chat in @chatting
      @tabs.push
        url: "#/chatting/#{chat.id}"
        name: chat.name
  methods:
    tabOnClick: (tab) ->
      # @thisContact = @client.getContactByName tab.name
      # @thisContact.getRecentMessages(20).then (messages) =>
      #   console.log messages
      #   @messages = messages
    changeContent: ->
      if @clickedChat
        @thisContact = @client.getContactById @clickedChat
        @thisContact.getRecentMessages(20).then (messages) =>
          @messages = _.map messages.reverse(), (message) =>
            @checkMessageType message
          console.log @messages
          # chatTabScrollToBottom()
    changeMessages: ->
      polled = @polledMessage.slice @polledIdx
      @polledIdx = polled.length
      _.each polled, (value) =>
        console.log value
        if (value[0] and value[0].id is @clickedChat) or (value[1])
          @messages.push @checkMessageType(value[2])
          # chatTabScrollToBottom()
        else
          @notification.push value
        console.log @notification
    submit: () ->
      console.log "Submit message: #{@message}"
      if @message
        @thisContact.sendMessage @message
        @message = null
    checkMessageType: (message) ->
      switch message.contentType
        when 1 # Image
          message.image = message.contentMetaData.PREVIEW_URL if message.contentMetaData and message.contentMetaData.PREVIEW_URL
          # console.log message.contentMetaData
          if message.contentPreview
            # message.base64 = "data:image/jpeg;base64,#{new Buffer(stripBom(message.contentPreview)).toString('base64')}"
            # console.log new Buffer(message.contentPreview).toString('hex')
            msg = stripBom(new Buffer(message.contentPreview, 'raw'))
            # fs = require 'fs'
            # fs.writeFile 'test.jpg', msg.toString('binary'), 'binary', (err) ->
            #   console.log err if err
            #   console.log 'File saved'
            # http = require 'http'
            # http.get 'http://wallpaperart.altervista.org/Immagini/barta-simpson-1280x800.jpg', (res) ->
            #   imagedata = ''
            #   res.setEncoding 'binary'
            #   res.on 'data', (chunk) ->
            #     imagedata += chunk
            #   res.on 'end', ->
            #     fs.writeFile 'bart.jpg', imagedata, 'binary', (err) ->
            #       console.log err if err
            #       console.log 'File saved'
            # console.log buf

            # message.base64 += btoa unescape encodeURIComponent message.contentPreview
            # console.log new Buffer(message.contentPreview).toString('hex')
        when 2 # Video
          message.video = "http://#{@client.config.LINE_OS_URL}/os/m/#{message.id}/preview"
          console.log message.contentMetaData
        when 3 # Audio
          message.audio = "http://#{@client.config.LINE_OS_URL}/os/m/#{message.id}/preview"
          console.log message.contentMetaData
        when 7 # Sticker
          VER = createStickerVer message.contentMetaData.STKVER
          message.sticker = "http://#{@client.config.LINE_STICKER_URL}/#{VER}/#{message.contentMetaData.STKPKGID}/PC/stickers/#{message.contentMetaData.STKID}.png"
      message
  components:
    'tab-view': require '../components/tab-view.vue'
    'chat-messages': require '../components/chat-messages.vue'

chatTabScrollToBottom = ->
  (()->
    chatTab = document.getElementsByClassName('jsline-chat-tab-content')[0]
    chatTab.scrollTop = chatTab.scrollHeight
  )()

createStickerVer = (stkver) ->
  first = Math.floor(stkver / 1000000)
  second = Math.floor(stkver /1000)
  third = stkver % 1000
  "#{first}/#{second}/#{third}"
</script>
