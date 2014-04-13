@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Models
  ##############################################################################

  class Entities.Address extends Entities.Model
    displayName: ->
      if @get('name')
        @get('name')
      else
        @get('public_address')

    fetchCurrency: (opts = {}) ->
      _.defaults opts,
        url: Routes.detect_currency_addresses_path()
        data:
          public_address: @get('public_address')

      @fetch opts

    fetchInfo: (opts) ->
      _.defaults opts,
        url: Routes.info_addresses_path()
        data:
          public_address: @get('public_address')

      @fetch opts


  ##############################################################################
  # Collections
  ##############################################################################

  class Entities.Addresses extends Entities.Collection
    model: Entities.Address
    url: -> Routes.addresses_path()
    sortOrder: 'name'
    conversion: 'all'
