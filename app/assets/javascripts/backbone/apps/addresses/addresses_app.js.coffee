@Balances.module 'AddressesApp', (AddressesApp, App, Backbone, Marionette, $, _) ->

  class AddressesApp.Router extends Marionette.AppRouter
    appRoutes:
      'addresses': 'index'

    controller:
      index: ->
        new AddressesApp.Index.Controller

  App.addInitializer ->
    new AddressesApp.Router
