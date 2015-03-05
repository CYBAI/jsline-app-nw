<style lang="stylus">
</style>

<template lang="jade">
ul.nav.nav-tabs
  li(v-repeat="tab: tabs", v-on="click: tabOnClick(tab)")
    a(href="{{tab.url}}") {{tab.name}}
div(v-component="{{contentView}}", class="{{tabContentClass}}", v-on="scroll: scroll", keep-alive)
</template>

<script lang="coffee">
module.exports =
  inherit: true
  methods:
    scroll: (e) ->
      console.log e
      console.log e.target.scrollTop
      console.log e.target.offsetHeight
      console.log e.target.scrollHeight
</script>
