<style lang="stylus">
.statusMessage
  text-align right
  overflow hidden
  height 3em
</style>

<template lang="jade">
div(id="{{content.id}}", class="item row", v-repeat="content: contents", v-on="click: chatMember(content)")
  img(draggable="false", v-attr="src: content.iconPath", class="img-rounded col-md-3 col-sm-3")
  label.username.col-md-6.col-sm-6 {{content.name}}
  div.statusMessage.col-md-3.col-sm-3 {{content.statusMessage}}
</template>

<script lang="coffee">
module.exports =
  inherit: true
</script>
