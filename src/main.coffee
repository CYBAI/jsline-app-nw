'use strict'

require 'jquery'
require 'bootstrap'
require 'bootstrap-material-design'
require 'lodash'
require 'bluebird'
require 'regenerator/runtime'

Vue = require 'vue'
Vue.config.debug = true

Router = require('director').Router
router = new Router()

app = new Vue require './app.vue'

router.on '/chatting/:id', (id) ->
  app.clickedChat = id
  app.chatView = 'user-chat-view' if app.chatView is 'logo-view'

router.on '/contactlist', () ->
  app.chatView = if app.chatting.length is 0 then 'logo-view' else 'user-chat-view'
  app.contactView = 'contacts-list-view'

router.on '/chatlist', () ->
  app.chatView = if app.chatting.length is 0 then 'logo-view' else 'user-chat-view'
  app.contactView = 'chatbox-list-view'

# router.on '/contactlist/:ids', (ids) ->
#   console.log ids
#   if ids.length is 0
#     app.chatView = 'logo-view'
#   else
#     app.chatting = ids.split ','
#     app.chatView = 'user-chat-view'
#   app.contactView = 'contacts-list-view'
#
# router.on '/chatlist/:ids', (ids) ->
#   console.log ids
#   if ids.length is 0
#     app.chatView = 'logo-view'
#   else
#     app.chatting = ids.split ','
#     app.chatView = 'user-chat-view'
#   app.contactView = 'chatbox-list-view'

router.on '/', () ->
  app.chatView = if app.chatting.length is 0 then 'logo-view' else 'user-chat-view'

router.configure
  notfound: () ->
    router.setRoute '/'

# plugin initial
router.init '/'
$.material.init()
