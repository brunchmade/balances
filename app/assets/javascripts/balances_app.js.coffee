@BalancesApp = new Backbone.Marionette.Application

@BalancesApp.addRegions
  addressListRegion: '#address-list-region'

@BalancesApp.addInitializer (options) ->
  addressListView = new B.Views.AddressList collection: B.currentUser.addresses
  @addressListRegion.show addressListView
