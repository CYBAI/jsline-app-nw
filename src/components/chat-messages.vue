<style lang="stylus">
.receiver
  margin-left 20px
  float right
.sender
  margin-right 20px
  float left
.message
  padding 5px 0
  line-height 1.28
  text-align left
  margin 0 4px
  overflow hidden
</style>

<template lang="jade">
div(class="message", v-repeat="message: messages")
  div(v-class="receiver: message.receiver, sender: !message.receiver")
    span(v-if="message.contentType === 0") {{message.text}}
    img(v-if="message.image", v-attr="src: message.image")
    img(v-if="message.base64", v-attr="src: message.base64")
    img(draggable="false", v-if="message.sticker", v-attr="src: message.sticker")
    audio(v-if="message.audio", v-attr="src: message.audio")
    video(v-if="message.video", v-attr="message.video")
</template>

<script lang="coffee">
module.exports =
  inherit: true
</script>
