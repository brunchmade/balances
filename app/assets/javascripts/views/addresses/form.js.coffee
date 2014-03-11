class B.Views.AddressForm extends Backbone.Marionette.ItemView

  template: HandlebarsTemplates['addresses/form']
  id: 'address-form'
  tagName: 'article'

  events:
    'keydown .address-public-address': '_handleKeyupInput'
    'paste .address-public-address': '_handlePasteInput'
    'cut .address-public-address': '_handleCutInput'
    'click .btn-save': '_handleSave'
    'click .btn-cancel': '_handleCancel'

  onShow: ->
    @balance = @$('.address-balance')
    @currencyType = @$('.currency-type')
    @inputAddress = @$('.address-public-address')
    @inputName = @$('.address-name')
    @hiddenAddress = @$('.hidden-public-address')
    @hiddenAddressFirstbits = @$('.hidden-public-firstbits')
    @btnQrScan = @$('.scan-qr')
    @btnSave = @$('.btn-save')
    @btnCancel = @$('.btn-cancel')

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
            @_setCurrencyImage response
      else
        @model.info
          data:
            public_address: inputVal
          success: (response) =>
            if response.is_valid
              @_isValidAddress response
            else
              @_addError()
          error: =>
            @_addError()
    , 800

  _handlePasteInput: (event) ->
    # Timeout so that the paste event completes and the input has data.
    $.doTimeout 50, =>
      inputVal = @inputAddress.val()
      @_clearErrors()
      @_clearCurrencyImage()

      if inputVal.length < 27 or inputVal.length > 34
        @_addError()
        return

      @model.info
        data:
          public_address: inputVal
        success: (response) =>
          if response.is_valid
            @_isValidAddress response
          else
            @_addError()
        error: =>
          @_addError()

  _handleCutInput: (event) ->
    # Timeout so that the cut event completes and the input has data.
    $.doTimeout 50, =>
      if @inputAddress.val().length is 0
        @_clearErrors()
        @_clearCurrencyImage()

  _handleSave: (event) ->
    event.preventDefault()
    balance = @balance.text()
    @collection.create
      balance: balance.slice(0, _.indexOf(balance, ' '))
      currency: @currencyType.find('img').attr('alt')
      name: _.string.trim(@inputName.val())
      public_address: _.string.trim(@inputAddress.val())
    ,
      wait: true
      success: (model, response, options) =>
        @_reset()
      error: (model, response, options) ->
        _.each JSON.parse(response.responseText).errors, (msg, key) =>
          mark "#{_.string.titleize(_.string.humanize(key))} #{msg}"

  _handleCancel: (event) ->
    event.preventDefault()
    @_reset(false)

  _setCurrencyImage: (response) ->
    @currencyType.addClass('is-filled').html $('<img />',
      src: response.currency_image_path
      alt: response.currency)

  _isValidAddress: (response) ->
    @_setCurrencyImage response
    @btnQrScan.hide()
    @btnSave.css('display', 'inline-block')
    @btnCancel.css('display', 'inline-block')
    @hiddenAddressFirstbits.text @inputAddress.val().slice(0,8)
    @inputAddress
      .addClass('is-valid')
      .css('width', @hiddenAddressFirstbits.outerWidth())
      .prop('disabled', true)
    @balance.text("#{response.balance} #{response.shortname}").show()
    inputNameWidth = @$('.address-input').outerWidth() - @inputAddress.outerWidth() - @balance.outerWidth() - 10
    @inputName.css('width', inputNameWidth).show().focus()
    @

  _addError: ->
    @inputAddress.addClass 'is-invalid'

  _clearErrors: ->
    @inputAddress.removeClass 'is-invalid'

  _clearCurrencyImage: ->
    @currencyType.removeClass('is-filled').html('')

  _reset: (clearAddress = true) ->
    @_clearErrors()
    @_clearCurrencyImage()
    @btnQrScan.show()
    @btnSave.hide()
    @btnCancel.hide()
    @inputName.val('').hide()
    @balance.text('').hide()
    @inputAddress.removeClass('is-valid').prop('disabled', false).css('width', '100%')
    @inputAddress.val('') if clearAddress
