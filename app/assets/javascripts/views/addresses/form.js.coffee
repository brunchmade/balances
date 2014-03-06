class B.Views.AddressForm extends Backbone.Marionette.ItemView

  template: HandlebarsTemplates['addresses/form']
  id: 'address-form'
  tagName: 'article'

  events:
    'keyup input': '_handleKeyupInput'
    'paste input': '_handlePasteInput'

  _handleKeyupInput:
    _.debounce =>
      mark 'testing'
    , 500

  _handlePasteInput: (event) ->
    # Timeout so that the paste event completes and the input has data.
    $.doTimeout 50, =>
      @model.detect_currency
        data:
          public_address: $(event.currentTarget).val()
        success: (response) =>
          @$('.currency-type').addClass('is-filled').html $('<img />',
            src: response.currency_image_path
            alt: response.currency)
        error: ->
          alert "Sorry we don't recognize your address :( please try again."
