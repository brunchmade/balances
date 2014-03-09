class B.Views.AddressForm extends Backbone.Marionette.ItemView

  template: HandlebarsTemplates['addresses/form']
  id: 'address-form'
  tagName: 'article'

  events:
    'keydown .public-address': '_handleKeyupInput'
    'paste .public-address': '_handlePasteInput'
    'cut .public-address': '_handleCutInput'

  onShow: ->
    @inputAddress or= @$('.public-address')
    @inputName or= @$('.name')

  _handleKeyupInput:
    _.debounce (event) ->
      return if isPasteKey(event) or
                isSelectAllKey(event) or
                isArrowKey(event)

      inputVal = @inputAddress.val()
      @_clearErrors()

      if inputVal.length is 0
        @_clearCurrencyImage()
      else if inputVal.length < 27
        @model.detectCurrency
          data:
            public_address: inputVal
          success: (response) =>
            @$('.currency-type').addClass('is-filled').html $('<img />',
              src: response.currency_image_path
              alt: response.currency)
      else
        @model.info
          data:
            public_address: inputVal
          success: (response) =>
            if response.is_valid
              @$('.currency-type').addClass('is-filled').html $('<img />',
                src: response.currency_image_path
                alt: response.currency)
            else
              @_addError()
          error: =>
            @_addError()
    , 800

  _handlePasteInput: (event) ->
    # Timeout so that the paste event completes and the input has data.
    $.doTimeout 50, =>
      inputVal = @inputAddress.val()
      @_reset()

      if inputVal.length < 27 or inputVal.length > 34
        @_addError()
        return

      @model.info
        data:
          public_address: inputVal
        success: (response) =>
          if response.is_valid
            @$('.currency-type').addClass('is-filled').html $('<img />',
              src: response.currency_image_path
              alt: response.currency)
          else
            @_addError()
        error: =>
          @_addError()

  _handleCutInput: (event) ->
    # Timeout so that the cut event completes and the input has data.
    $.doTimeout 50, =>
      @_reset() if @inputAddress.val().length is 0

  _addError: ->
    @inputAddress.addClass 'is-invalid'

  _clearErrors: ->
    @inputAddress.removeClass 'is-invalid'

  _clearCurrencyImage: ->
    @$('.currency-type').removeClass('is-filled').html('')

  _reset: ->
    @_clearErrors()
    @_clearCurrencyImage()
