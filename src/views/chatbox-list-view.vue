<style lang="stylus">
</style>

<template lang="jade">
div(id="{{eachChat.id}}", class="item row", v-repeat="eachChat: chatting", v-on="click: chatMember(eachChat)")
  img(draggable="false", v-attr="src: eachChat.iconPath", class="img-rounded col-md-3 col-sm-3")
  label.username.col-md-6.col-sm-6 {{eachChat.name}}
</template>

<script lang="coffee">
module.exports =
  inherit: true
</script>
