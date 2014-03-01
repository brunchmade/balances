$(document).ready ->
  $('#address_public_address').on 'paste', (event) ->
    # Timeout so that the paste event completes and the input has data.
    $.doTimeout 50, ->
      $.ajax
        url: Routes.detect_currency_addresses_path()
        type: 'get'
        dataType: 'json'
        data:
          public_address: $(event.currentTarget).val()
        success: (response) ->
          if response.currency.length is 1
            $('#address_currency').val response.currency[0]
          else if response.currency.length > 0
            alert 'Your address matches multiple currencies ' + response.currency
          else
            alert 'We could not find a currency that matches that address.'
        error: ->
          alert 'Something went wrong :( please try again.'
