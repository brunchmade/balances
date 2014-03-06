@BalancesApp = new Backbone.Marionette.Application

@BalancesApp.addRegions
  addressFormRegion: '#address-form-region'
  addressListRegion: '#address-list-region'

@BalancesApp.addInitializer (options) ->
  @addressFormRegion.show new B.Views.AddressForm
    model: new B.Models.Address
    collection: B.currentUser.addresses

  @addressListRegion.show new B.Views.AddressList
    collection: B.currentUser.addresses
