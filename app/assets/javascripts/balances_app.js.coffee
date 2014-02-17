@BalancesApp = new Backbone.Marionette.Application

@BalancesApp.addRegions
  addressListRegion: '#addressListRegion'

@BalancesApp.addInitializer (options) ->
  addressListView = new B.Views.AddressList
  @addressListRegion.show addressListView
