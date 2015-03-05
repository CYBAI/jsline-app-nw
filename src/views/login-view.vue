<style lang="stylus">
  form
    padding 20px
  .loginLogo
    display block
    margin-left auto
    margin-right auto
  .jsline-row
    width 100%
    white-space nowrap
  .jsline-row div
    display inline-block
    width 50%
  #checkRemember
    text-align left
  #loginBtn
    text-algn right
</style>

<template lang="jade">
div#loginBody
  form#loginForm.form-horizontal
    img(class="loginLogo", draggable="false", v-attr="src: 'src/images/login_logo.png'")
    p.form-group
      label(for="account") Email
      input(type="text", id="account", name="account", class="form-control", v-model="account", placeholder="Input your email")
    p.form-group
      label(for="password") Password
      input(type="password", id="password", name="password", class="form-control", v-model="password", placeholder="Input your password")
    p.form-group
      div.jsline-row
        div#checkRemember.checkbox
          label(for="remember")
            input(id="remember", type="checkbox", v-model="rememberAccount")
            | Remember
        div(id="loginBtn", class="btn btn-default", v-on="click: login(account, password)") Login
</template>

<script lang="coffee">
module.exports =
  el: ->
    '#loginBody'
  inherit: true
  data: ->
    account: localStorage.getItem 'account'
    password: localStorage.getItem 'password'
    rememberAccount: localStorage.getItem 'rememberAccount'
  methods:
    login: (account, password) ->
      if not account or not password
        console.log 'Missing email or password'
        return
      if not @client
        if not localStorage.getItem 'authToken'
          @client = new @jslineApi.LineClient account, password
        else
          @client = new @jslineApi.LineClient account, password, localStorage.getItem('authToken'), localStorage.getItem('certificate')
      @client.login().then (result) =>
        if @rememberAccount
          localStorage.setItem 'rememberAccount', @rememberAccount
          localStorage.setItem 'account', @account
          localStorage.setItem 'password', @password
        else
          localStorage.setItem 'rememberAccount', @rememberAccount
          localStorage.removeItem 'account'
          localStorage.removeItem 'password'
        if result
          localStorage.setItem 'authToken', result.authToken
          localStorage.setItem 'certificate', result.certificate
          @logined = true
        else
          localStorage.removeItem 'authToken'
          localStorage.removeItem 'certificate'
          console.log 'Login Failed'
</script>
