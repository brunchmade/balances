@Balances = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = Routes.addresses_path()

  App.on 'initialize:before', (options) ->
    @currentUser = new App.Entities.CurrentUser options.currentUser,
      addresses: options.addresses

  App.addRegions
    mainRegion: '#main-region'

  App.on 'initialize:after', (options) ->
    if Backbone.history
      Backbone.history.start(pushState: true)
      @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ''

  App.reqres.setHandler 'get:current:user', ->
    App.currentUser

  App
