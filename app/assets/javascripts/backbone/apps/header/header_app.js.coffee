@Balances.module 'HeaderApp', (HeaderApp, App, Backbone, Marionette, $, _) ->

  HeaderApp.on 'start', ->
    new HeaderApp.Show.Controller
