class B.Models.Address extends Backbone.Model

  detect_currency: (opts = {}) ->
    $.ajax
      url: Routes.detect_currency_addresses_path()
      type: 'get'
      dataType: 'json'
      data: opts.data
      success: (response) =>
        opts.success?(response)
      error: ->
        opts.error?()
