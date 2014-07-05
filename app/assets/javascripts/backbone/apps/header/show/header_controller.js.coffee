@Balances.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base
    initialize: ->
      @layout = new Show.Layout
        model: App.currentUser

      @listenTo @layout, 'show', ->
        @showBalance() if App.currentUser.isSignedIn()

      App.mainHeaderRegion.show @layout

    showBalance: ->
      @layout.balanceRegion.show new Show.Balance
        model: App.currentUser
