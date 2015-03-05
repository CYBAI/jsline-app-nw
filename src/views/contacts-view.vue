<style lang="stylus">
  .item
    padding 8px 9px 8px 9px
    background-color #FFF
    border-bottom 1px solid #E8E8E8
  .item:hover
    background-color #F7FAFE
    cursor pointer
  .item img
    width 20%
    height 20%
  .item .username
    padding-left 10px

  .jsline-contact-tab-content
    height 92vh
    overflow-x hidden
    overflow-y auto
    padding-right 1px
    padding-left 1px
    margin-right auto
    margin-left auto
</style>

<template lang="jade">
div(v-component="login-view", v-show="!logined")
div(v-component="tab-view", v-show="logined")
</template>

<script lang="coffee">
module.exports =
  el: ->
    '#contactsbox'
  inherit: true
  data: ->
    tabs: [
      {
        name: 'Friends'
        active: true
        origin: '#/contactlist'
        url: '#/contactlist'
      }
      {
        name: 'Chats'
        active: false
        origin: '#/chatlist'
        url: '#/chatlist'
      }
    ]
    tabContentClass: 'jsline-contact-tab-content'
    contentView: @contactView
  watch:
    'contactView': 'changeView'
    'logined': 'loadContacts'
  methods:
    changeView: () ->
      @contentView = @contactView
    loadContacts: () ->
      if @logined
        @contents = @client.contacts
        @nwCookies.get
          url: 'file:///'
          name: 'ids'
        , (cookie) =>
          ids = cookie.value.split ','
          @chatting.push @client.getContactById id for id in ids
          true
    tabOnClick: (tab) ->
      # if tab.url.indexOf('contact') isnt -1
      #   @contents = @client.contacts
      # else
      #   @contents = @chatting
    chatMember: (contact) ->
      finded = _.find @chatting, (cont) ->
        cont.name is contact.name
      if not finded
        @chatting.push contact
      @nwCookies.set
        url: 'file:///'
        name: 'ids'
        value: @chatting.toString()
        expirationDate: Date.now() + 60*60*24*1000
      document.location.hash = "#/chatting/#{contact.id}"
  components:
    'tab-view': require '../components/tab-view.vue'
    'chatbox-list-view': require './chatbox-list-view.vue'
    'contacts-list-view': require './contacts-list-view.vue'
</script>
