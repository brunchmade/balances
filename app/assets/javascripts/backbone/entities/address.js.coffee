@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Models
  ##############################################################################

  class Entities.Address extends Entities.Model
    detectCurrency: (opts = {}) ->
      $.ajax
        url: Routes.detect_currency_addresses_path()
        type: 'get'
        dataType: 'json'
        data: opts.data
        success: (response) =>
          opts.success?(response)
        error: ->
          opts.error?()

    info: (opts = {}) ->
      $.ajax
        url: Routes.info_addresses_path()
        type: 'get'
        dataType: 'json'
        data: opts.data
        success: (response) =>
          opts.success?(response)
        error: ->
          opts.error?()

  ##############################################################################
  # Collections
  ##############################################################################

  class Entities.Addresses extends Entities.Collection
    model: Entities.Address
    url: -> Routes.addresses_path()
    sortOrder: 'name'
    conversion: 'all'
