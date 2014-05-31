@Balances.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base
    initialize: ->
      @layout = new Show.Layout
        model: App.currentUser

      App.mainHeaderRegion.show @layout
