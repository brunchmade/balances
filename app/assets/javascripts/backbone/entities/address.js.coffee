@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  #############################################################################
  # Models
  #############################################################################

  class Entities.Address extends Entities.Model
    initialize: (attributes, options = {}) ->
      @set edit_mode: false

    displayName: ->
      @get('name') or @get('public_address')

    fetchCurrency: (options = {}) ->
      _.defaults options,
        url: Routes.detect_currency_addresses_path()
        data:
          public_address: @get('public_address')

      @fetch options

    fetchInfo: (options = {}) ->
      _.defaults options,
        url: Routes.info_addresses_path()
        data:
          public_address: @get('public_address')

      @fetch options


  #############################################################################
  # Collections
  #############################################################################

  class Entities.Addresses extends Entities.Collection
    model: Entities.Address
    url: -> Routes.addresses_path()

    defaultSortOrder: 'name'
    defaultConversion: 'all'
    defaultCurrencyFilter: 'all'

    initialize: (models, options = {}) ->
      _.defaults options,
        sortOrder: @defaultSortOrder
        conversion: @defaultConversion
        currencyFilter: @defaultCurrencyFilter

      @sortOrder = options.sortOrder
      @conversion = options.conversion
      @currencyFilter = options.currencyFilter

    setSortOrder: (sortOrder) ->
      @sortOrder = sortOrder
      @trigger 'change:sort:order'

    setConversion: (conversion) ->
      @conversion = conversion
      @trigger 'change:conversion'

    setCurrencyFilter: (currencyFilter) ->
      @currencyFilter = currencyFilter
      @trigger 'change:currency:filter'
