@Balances = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = Routes.addresses_path()

  App.on 'initialize:before', (options) ->
    @currentUser = new App.Entities.CurrentUser options.currentUser,
      addresses: options.addresses
    startingFiatCurrency = @currentUser.get('last_selected_fiat') or gon.default_fiat_currency
    @fiatCurrency = gon.fiat_currencies[startingFiatCurrency]

  App.addRegions
    mainHeaderRegion: '#main-header-region'
    mainContentRegion: '#main-content-region'

  App.addInitializer ->
    App.module('HeaderApp').start()

  App.on 'initialize:after', (options) ->
    if Backbone.history
      Backbone.history.start(pushState: true)
      @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ''

  # Updates the Apps selected Fiat Currency and triggers an event to let views know.
  App.commands.setHandler 'update:fiat:currency', (fiatCurrencyShortName) =>
    App.currentUser.save last_selected_fiat: fiatCurrencyShortName
    App.fiatCurrency = gon.fiat_currencies[fiatCurrencyShortName]
    App.vent.trigger 'updated:fiat:currency'

  App
