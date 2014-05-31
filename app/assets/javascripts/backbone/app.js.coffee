@Balances = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = Routes.addresses_path()

  App.on 'initialize:before', (options) ->
    @currentUser = new App.Entities.CurrentUser options.currentUser,
      addresses: options.addresses
    @fiatCurrency = gon.fiat_currencies[gon.default_fiat_currency]

  App.addRegions
    mainHeaderRegion: '#main-header-region'
    mainContentRegion: '#main-content-region'

  App.addInitializer ->
    App.module('HeaderApp').start()

  App.on 'initialize:after', (options) ->
    if Backbone.history
      Backbone.history.start(pushState: true)
      @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ''


  App.commands.setHandler 'update:fiat:currency', (fiatCurrencyShortName) =>
    App.fiatCurrency = gon.fiat_currencies[fiatCurrencyShortName]
    App.vent.trigger 'updated:fiat:currency'

  App
